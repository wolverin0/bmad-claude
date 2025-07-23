#!/usr/bin/env node

/**
 * BMAD Method MCP Server
 * Automatically selects and applies the best BMAD persona based on user prompts
 */

import { Server } from '@modelcontextprotocol/sdk/server/index.js';
import { StdioServerTransport } from '@modelcontextprotocol/sdk/server/stdio.js';
import {
  CallToolRequestSchema,
  ListToolsRequestSchema,
} from '@modelcontextprotocol/sdk/types.js';
import fetch from 'node-fetch';

// BMAD Personas mapping (you'd expand this with all personas from the repo)
const BMAD_PERSONAS = {
  // Development personas
  'senior-dev': {
    name: 'Senior Developer',
    keywords: ['code', 'programming', 'development', 'function', 'class', 'algorithm', 'debug', 'refactor'],
    command: '/dev',
    description: 'Expert software developer for coding tasks'
  },
  'code-reviewer': {
    name: 'Code Reviewer',
    keywords: ['review', 'audit', 'quality', 'best practices', 'security', 'performance'],
    command: '/review',
    description: 'Thorough code review and quality assessment'
  },
  'architect': {
    name: 'Software Architect',
    keywords: ['architecture', 'design', 'system', 'structure', 'patterns', 'scalability'],
    command: '/architect',
    description: 'System design and architectural guidance'
  },
  
  // Analysis personas
  'data-analyst': {
    name: 'Data Analyst',
    keywords: ['data', 'analysis', 'statistics', 'visualization', 'insights', 'metrics'],
    command: '/analyze',
    description: 'Data analysis and statistical insights'
  },
  'business-analyst': {
    name: 'Business Analyst',
    keywords: ['business', 'requirements', 'process', 'workflow', 'stakeholder'],
    command: '/business',
    description: 'Business process analysis and requirements'
  },
  
  // Creative personas
  'creative-writer': {
    name: 'Creative Writer',
    keywords: ['write', 'story', 'content', 'creative', 'narrative', 'blog'],
    command: '/write',
    description: 'Creative writing and content creation'
  },
  
  // Technical documentation
  'tech-writer': {
    name: 'Technical Writer',
    keywords: ['documentation', 'manual', 'guide', 'tutorial', 'explain', 'how-to'],
    command: '/doc',
    description: 'Technical documentation and guides'
  },
  
  // Problem solving
  'problem-solver': {
    name: 'Problem Solver',
    keywords: ['problem', 'solve', 'issue', 'troubleshoot', 'fix', 'solution'],
    command: '/solve',
    description: 'General problem solving and troubleshooting'
  }
};

class BMADMethodServer {
  private server: Server;

  constructor() {
    this.server = new Server(
      {
        name: 'bmad-method-server',
        version: '0.1.0',
      },
      {
        capabilities: {
          tools: {},
        },
      }
    );

    this.setupToolHandlers();
  }

  private setupToolHandlers() {
    this.server.setRequestHandler(ListToolsRequestSchema, async () => {
      return {
        tools: [
          {
            name: 'enhance_prompt',
            description: 'Automatically enhance prompts with the best BMAD persona and commands',
            inputSchema: {
              type: 'object',
              properties: {
                prompt: {
                  type: 'string',
                  description: 'The original prompt to enhance',
                },
                context: {
                  type: 'string',
                  description: 'Additional context about the task (optional)',
                },
              },
              required: ['prompt'],
            },
          },
          {
            name: 'suggest_persona',
            description: 'Suggest the best BMAD persona for a given prompt without modifying it',
            inputSchema: {
              type: 'object',
              properties: {
                prompt: {
                  type: 'string',
                  description: 'The prompt to analyze',
                },
              },
              required: ['prompt'],
            },
          },
          {
            name: 'list_personas',
            description: 'List all available BMAD personas and their commands',
            inputSchema: {
              type: 'object',
              properties: {},
            },
          },
        ],
      };
    });

    this.server.setRequestHandler(CallToolRequestSchema, async (request) => {
      switch (request.params.name) {
        case 'enhance_prompt':
          return await this.enhancePrompt(
            request.params.arguments?.prompt as string,
            request.params.arguments?.context as string
          );
        
        case 'suggest_persona':
          return await this.suggestPersona(request.params.arguments?.prompt as string);
        
        case 'list_personas':
          return await this.listPersonas();
        
        default:
          throw new Error(`Unknown tool: ${request.params.name}`);
      }
    });
  }

  private async enhancePrompt(prompt: string, context?: string): Promise<any> {
    try {
      const analysis = this.analyzePrompt(prompt, context);
      const persona = this.selectBestPersona(analysis);
      
      if (!persona) {
        return {
          content: [
            {
              type: 'text',
              text: `Original prompt: ${prompt}\n\nNo specific persona detected. Using general problem-solving approach.`,
            },
          ],
        };
      }

      // Fetch the actual persona prompt from BMAD repo (you'd implement this)
      const personaPrompt = await this.fetchPersonaPrompt(persona);
      
      const enhancedPrompt = this.buildEnhancedPrompt(prompt, persona, personaPrompt, context);
      
      return {
        content: [
          {
            type: 'text',
            text: `🎯 **Selected Persona**: ${persona.name} (${persona.command})
📝 **Reasoning**: Detected keywords: ${analysis.detectedKeywords.join(', ')}

**Enhanced Prompt**:
${enhancedPrompt}`,
          },
        ],
      };
    } catch (error) {
      return {
        content: [
          {
            type: 'text',
            text: `Error enhancing prompt: ${error instanceof Error ? error.message : String(error)}`,
          },
        ],
        isError: true,
      };
    }
  }

  private async suggestPersona(prompt: string): Promise<any> {
    const analysis = this.analyzePrompt(prompt);
    const persona = this.selectBestPersona(analysis);
    
    if (!persona) {
      return {
        content: [
          {
            type: 'text',
            text: 'No specific persona recommended. General problem-solving approach suggested.',
          },
        ],
      };
    }

    return {
      content: [
        {
          type: 'text',
          text: `🎯 **Recommended Persona**: ${persona.name}
🔧 **Command**: ${persona.command}
📋 **Description**: ${persona.description}
🔍 **Detected Keywords**: ${analysis.detectedKeywords.join(', ')}
📊 **Confidence**: ${analysis.confidence.toFixed(2)}`,
        },
      ],
    };
  }

  private async listPersonas(): Promise<any> {
    const personaList = Object.entries(BMAD_PERSONAS)
      .map(([key, persona]) => `• **${persona.name}** (${persona.command}): ${persona.description}`)
      .join('\n');

    return {
      content: [
        {
          type: 'text',
          text: `📚 **Available BMAD Personas**:\n\n${personaList}`,
        },
      ],
    };
  }

  private analyzePrompt(prompt: string, context?: string): {
    detectedKeywords: string[];
    confidence: number;
    category: string;
  } {
    const fullText = `${prompt} ${context || ''}`.toLowerCase();
    const detectedKeywords: string[] = [];
    let maxMatches = 0;
    let bestCategory = 'general';

    // Analyze keywords for each persona
    for (const [key, persona] of Object.entries(BMAD_PERSONAS)) {
      const matches = persona.keywords.filter(keyword => 
        fullText.includes(keyword.toLowerCase())
      );
      
      if (matches.length > 0) {
        detectedKeywords.push(...matches);
        if (matches.length > maxMatches) {
          maxMatches = matches.length;
          bestCategory = key;
        }
      }
    }

    // Calculate confidence based on keyword matches
    const confidence = Math.min(maxMatches / 3, 1.0); // Max confidence with 3+ keyword matches

    return {
      detectedKeywords: [...new Set(detectedKeywords)], // Remove duplicates
      confidence,
      category: bestCategory
    };
  }

  private selectBestPersona(analysis: any) {
    if (analysis.confidence < 0.3) {
      return null; // Not confident enough
    }

    return BMAD_PERSONAS[analysis.category as keyof typeof BMAD_PERSONAS];
  }

  private async fetchPersonaPrompt(persona: any): Promise<string> {
    // In a real implementation, you'd fetch from the BMAD repo
    // For now, return a placeholder
    return `You are ${persona.name}. ${persona.description}. Please approach this task with your specialized expertise.`;
  }

  private buildEnhancedPrompt(
    originalPrompt: string,
    persona: any,
    personaPrompt: string,
    context?: string
  ): string {
    let enhanced = `${persona.command}\n\n${personaPrompt}\n\n`;
    
    if (context) {
      enhanced += `**Context**: ${context}\n\n`;
    }
    
    enhanced += `**Task**: ${originalPrompt}`;
    
    return enhanced;
  }

  async run() {
    const transport = new StdioServerTransport();
    await this.server.connect(transport);
    console.error('BMAD Method MCP server running on stdio');
  }
}

const server = new BMADMethodServer();
server.run().catch(console.error);