import { Client } from '@notionhq/client';

const notion = new Client({
  auth: import.meta.env.NOTION_API_KEY,
});

export interface FAQItem {
  id: string;
  question: string;
  answer: string;
}

export async function getFAQItems(): Promise<FAQItem[]> {
  const response = await notion.databases.query({
    database_id: import.meta.env.NOTION_DATABASE_ID,
  });

  return response.results.map((page: any) => ({
    id: page.properties.id?.title?.[0]?.plain_text ?? '',
    question: page.properties.question?.rich_text?.[0]?.plain_text ?? '',
    answer: page.properties.answer?.rich_text?.[0]?.plain_text ?? '',
  }));
}
