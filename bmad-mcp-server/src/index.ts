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

// Enhanced BMAD Personas mapping based on the official repository
const BMAD_PERSONAS = {
  // Development personas
  'senior-dev': {
    name: 'Senior Developer',
    keywords: ['code', 'programming', 'development', 'function', 'class', 'algorithm', 'debug', 'refactor', 'implement', 'build', 'create', 'fix', 'bug'],
    command: '/dev',
    description: 'Expert software developer for coding tasks, debugging, and implementation',
    context: 'You are a Senior Developer with 10+ years of experience. You write clean, efficient, well-documented code and follow best practices. You consider performance, security, and maintainability in all solutions.'
  },
  'code-reviewer': {
    name: 'Code Reviewer',
    keywords: ['review', 'audit', 'quality', 'best practices', 'security', 'performance', 'analyze', 'check', 'validate', 'inspect'],
    command: '/review',
    description: 'Thorough code review and quality assessment specialist',
    context: 'You are an expert Code Reviewer focused on code quality, security, performance, and best practices. You provide detailed feedback with specific suggestions for improvement.'
  },
  'software-architect': {
    name: 'Software Architect',
    keywords: ['architecture', 'design', 'system', 'structure', 'patterns', 'scalability', 'microservices', 'api', 'database', 'infrastructure'],
    command: '/architect',
    description: 'System design and architectural guidance expert',
    context: 'You are a Software Architect who designs scalable, maintainable systems. You think about high-level structure, design patterns, technology choices, and long-term evolution of systems.'
  },
  'devops-engineer': {
    name: 'DevOps Engineer',
    keywords: ['deploy', 'deployment', 'ci/cd', 'docker', 'kubernetes', 'aws', 'cloud', 'pipeline', 'automation', 'infrastructure'],
    command: '/devops',
    description: 'DevOps and infrastructure automation specialist',
    context: 'You are a DevOps Engineer expert in CI/CD, containerization, cloud platforms, and infrastructure automation. You focus on reliable, automated deployment pipelines.'
  },
  
  // Analysis personas
  'data-analyst': {
    name: 'Data Analyst',
    keywords: ['data', 'analysis', 'statistics', 'visualization', 'insights', 'metrics', 'csv', 'database', 'query', 'chart'],
    command: '/analyze',
    description: 'Data analysis and statistical insights specialist',
    context: 'You are a Data Analyst expert in statistical analysis, data visualization, and extracting actionable insights from data. You use appropriate tools and methods for data exploration.'
  },
  'business-analyst': {
    name: 'Business Analyst',
    keywords: ['business', 'requirements', 'process', 'workflow', 'stakeholder', 'user story', 'specification', 'analysis'],
    command: '/business',
    description: 'Business process analysis and requirements specialist',
    context: 'You are a Business Analyst who bridges technical and business teams. You excel at gathering requirements, documenting processes, and translating business needs into technical specifications.'
  },
  
  // Creative personas
  'creative-writer': {
    name: 'Creative Writer',
    keywords: ['write', 'story', 'content', 'creative', 'narrative', 'blog', 'article', 'copy', 'marketing'],
    command: '/write',
    description: 'Creative writing and content creation specialist',
    context: 'You are a Creative Writer with expertise in storytelling, content creation, and engaging writing. You adapt your tone and style to the target audience and purpose.'
  },
  
  // Documentation personas
  'tech-writer': {
    name: 'Technical Writer',
    keywords: ['documentation', 'manual', 'guide', 'tutorial', 'explain', 'how-to', 'readme', 'api docs'],
    command: '/doc',
    description: 'Technical documentation and guide creation specialist',
    context: 'You are a Technical Writer who creates clear, comprehensive documentation. You structure information logically and write for your target audience\'s technical level.'
  },
  
  // Problem solving personas
  'problem-solver': {
    name: 'Problem Solver',
    keywords: ['problem', 'solve', 'issue', 'troubleshoot', 'solution', 'error', 'help', 'fix'],
    command: '/solve',
    description: 'General problem solving and troubleshooting specialist',
    context: 'You are a Problem Solver who approaches challenges systematically. You break down complex problems, consider multiple solutions, and provide clear step-by-step guidance.'
  },
  
  // Security personas
  'security-expert': {
    name: 'Security Expert',
    keywords: ['security', 'vulnerability', 'penetration', 'encryption', 'authentication', 'authorization', 'threat', 'secure'],
    command: '/security',
    description: 'Cybersecurity and security assessment specialist',
    context: 'You are a Security Expert focused on identifying vulnerabilities, implementing security best practices, and ensuring robust security measures in systems and code.'
  }
};

// Workflow patterns for multi-persona scenarios
const WORKFLOW_PATTERNS = [
  {
    triggers: ['analyze', 'then', 'implement'],
    sequence: ['data-analyst', 'senior-dev'],
    description: 'Analysis followed by implementation'
  },
  {
    triggers: ['review', 'and', 'fix'],
    sequence: ['code-reviewer', 'senior-dev'],
    description: 'Code review followed by fixes'
  },
  {
    triggers: ['debug', 'and', 'document'],
    sequence: ['problem-solver', 'tech-writer'],
    description: 'Debugging followed by documentation'
  },
  {
    triggers: ['design', 'and', 'implement'],
    sequence: ['software-architect', 'senior-dev'],
    description: 'Architecture design followed by implementation'
  },
  {
    triggers: ['secure', 'and', 'review'],
    sequence: ['security-expert', 'code-reviewer'],
    description: 'Security analysis followed by code review'
  }
];

class BMADMethodServer {
  private server: Server;

  constructor() {
    this.server = new Server(
      {
        name: 'bmad-method-server',
        version: '1.0.0',
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
            description: 'Automatically enhance prompts with the best BMAD persona(s) and commands',
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
                force_persona: {
                  type: 'string',
                  description: 'Force a specific persona (optional): ' + Object.keys(BMAD_PERSONAS).join(', '),
                },
              },
              required: ['prompt'],
            },
          },
          {
            name: 'suggest_persona',
            description: 'Suggest the best BMAD persona(s) for a given prompt without modifying it',
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
          {
            name: 'detect_workflow',
            description: 'Detect if prompt requires multiple personas in sequence',
            inputSchema: {
              type: 'object',
              properties: {
                prompt: {
                  type: 'string',
                  description: 'The prompt to analyze for workflow patterns',
                },
              },
              required: ['prompt'],
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
            request.params.arguments?.context as string,
            request.params.arguments?.force_persona as string
          );
        
        case 'suggest_persona':
          return await this.suggestPersona(request.params.arguments?.prompt as string);
        
        case 'list_personas':
          return await this.listPersonas();
        
        case 'detect_workflow':
          return await this.detectWorkflow(request.params.arguments?.prompt as string);
        
        default:
          throw new Error(`Unknown tool: ${request.params.name}`);
      }
    });
  }

  private async enhancePrompt(prompt: string, context?: string, forcePersona?: string): Promise<any> {
    try {
      let selectedPersonas: any[] = [];
      
      if (forcePersona && BMAD_PERSONAS[forcePersona as keyof typeof BMAD_PERSONAS]) {
        selectedPersonas = [BMAD_PERSONAS[forcePersona as keyof typeof BMAD_PERSONAS]];
      } else {
        const workflowAnalysis = this.analyzeWorkflow(prompt, context);
        
        if (workflowAnalysis.isWorkflow) {
          selectedPersonas = workflowAnalysis.personas;
        } else {
          const analysis = this.analyzePrompt(prompt, context);
          const persona = this.selectBestPersona(analysis);
          if (persona) {
            selectedPersonas = [persona];
          }
        }
      }
      
      if (selectedPersonas.length === 0) {
        return {
          content: [
            {
              type: 'text',
              text: prompt, // Return original prompt if no persona detected
            },
          ],
        };
      }

      const enhancedPrompt = this.buildEnhancedPrompt(prompt, selectedPersonas, context);
      
      return {
        content: [
          {
            type: 'text',
            text: enhancedPrompt,
          },
        ],
      };
    } catch (error) {
      return {
        content: [
          {
            type: 'text',
            text: prompt, // Fallback to original prompt on error
          },
        ],
        isError: true,
      };
    }
  }

  private async suggestPersona(prompt: string): Promise<any> {
    const workflowAnalysis = this.analyzeWorkflow(prompt);
    
    if (workflowAnalysis.isWorkflow) {
      const personaNames = workflowAnalysis.personas.map(p => `${p.name} (${p.command})`).join(' → ');
      return {
        content: [
          {
            type: 'text',
            text: `🔄 **Workflow Detected**: ${workflowAnalysis.workflowType}\n📋 **Sequence**: ${personaNames}\n🔍 **Trigger Words**: ${workflowAnalysis.triggers.join(', ')}`,
          },
        ],
      };
    }

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
          text: `🎯 **Recommended Persona**: ${persona.name}\n🔧 **Command**: ${persona.command}\n📋 **Description**: ${persona.description}\n🔍 **Detected Keywords**: ${analysis.detectedKeywords.join(', ')}\n📊 **Confidence**: ${analysis.confidence.toFixed(2)}`,
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

  private async detectWorkflow(prompt: string): Promise<any> {
    const analysis = this.analyzeWorkflow(prompt);
    
    return {
      content: [
        {
          type: 'text',
          text: `🔍 **Workflow Analysis**:\n\n**Is Workflow**: ${analysis.isWorkflow}\n**Type**: ${analysis.workflowType || 'Single task'}\n**Triggers**: ${analysis.triggers.join(', ')}\n**Personas**: ${analysis.personas.map(p => p.name).join(' → ')}`,
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
    const categoryScores: { [key: string]: number } = {};

    // Analyze keywords for each persona
    for (const [key, persona] of Object.entries(BMAD_PERSONAS)) {
      const matches = persona.keywords.filter(keyword => 
        fullText.includes(keyword.toLowerCase())
      );
      
      if (matches.length > 0) {
        detectedKeywords.push(...matches);
        categoryScores[key] = matches.length;
        
        if (matches.length > maxMatches) {
          maxMatches = matches.length;
          bestCategory = key;
        }
      }
    }

    // Calculate confidence based on keyword matches and specificity
    const confidence = Math.min(maxMatches / 2, 1.0); // Max confidence with 2+ keyword matches

    return {
      detectedKeywords: [...new Set(detectedKeywords)], // Remove duplicates
      confidence,
      category: bestCategory
    };
  }

  private analyzeWorkflow(prompt: string, context?: string): {
    isWorkflow: boolean;
    workflowType?: string;
    triggers: string[];
    personas: any[];
  } {
    const fullText = `${prompt} ${context || ''}`.toLowerCase();
    
    for (const pattern of WORKFLOW_PATTERNS) {
      const foundTriggers = pattern.triggers.filter(trigger => 
        fullText.includes(trigger.toLowerCase())
      );
      
      if (foundTriggers.length >= 2) { // Need at least 2 trigger words for workflow
        const personas = pattern.sequence.map(key => BMAD_PERSONAS[key as keyof typeof BMAD_PERSONAS]);
        
        return {
          isWorkflow: true,
          workflowType: pattern.description,
          triggers: foundTriggers,
          personas
        };
      }
    }
    
    return {
      isWorkflow: false,
      triggers: [],
      personas: []
    };
  }

  private selectBestPersona(analysis: any) {
    if (analysis.confidence < 0.25) { // Lower threshold for better coverage
      return null;
    }

    return BMAD_PERSONAS[analysis.category as keyof typeof BMAD_PERSONAS];
  }

  private buildEnhancedPrompt(
    originalPrompt: string,
    personas: any[],
    context?: string
  ): string {
    const commands = personas.map(p => p.command).join(' ');
    const personaContexts = personas.map(p => p.context).join('\n\n');
    
    let enhanced = `${commands}\n\n${personaContexts}\n\n`;
    
    if (context) {
      enhanced += `**Additional Context**: ${context}\n\n`;
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