import { mainGitTree, octokit } from "#dashboard/lib/octokit";
import { Badge } from "#shadcn/components/badge";
import { Button } from "#shadcn/components/button";
import yaml from "js-yaml";
import {
  Card,
  CardHeader,
  CardTitle,
  CardDescription,
  CardContent,
} from "#shadcn/components/card";
import {
  Table,
  TableHeader,
  TableRow,
  TableHead,
  TableBody,
  TableCell,
} from "#shadcn/components/table";
import { Package } from "lucide-react";
import Link from "next/link";
import { deleteStore, getStores } from "#dashboard/lib/store/api";
import { DeleteButton } from "./page.parts";
import { revalidatePath } from "next/cache";

export default async function StoreListPage() {
  const allStores = await getStores();

  const stores = allStores.filter(
    (store) => store.domains.length > 0 && store.slug !== "template"
  );

  async function deleteStoreAction(slug: string) {
    "use server";

    deleteStore(slug);

    revalidatePath("/store");
  }

  return (
    <Card className="flex flex-col w-full" x-chunk="dashboard-05-chunk-3">
      <CardHeader className="flex flex-row items-start bg-muted/50">
        <div className="grid gap-0.5">
          <CardTitle>Stores</CardTitle>
          <CardDescription>Here are your stores</CardDescription>
        </div>
        <div className="flex items-center gap-1 ml-auto">
          <Button size="sm" variant="outline" className="h-8 gap-3" asChild>
            <Link href="/store/create">
              <Package className="h-3.5 w-3.5" />
              <span className="lg:sr-only xl:not-sr-only xl:whitespace-nowrap">
                Create Store
              </span>
            </Link>
          </Button>
        </div>
      </CardHeader>
      <CardContent>
        <Table>
          <TableHeader>
            <TableRow>
              <TableHead>Site Name</TableHead>
              <TableHead className="hidden sm:table-cell">Status</TableHead>
              <TableHead className="hidden md:table-cell">Date</TableHead>
              <TableHead className="hidden md:table-cell">Actions</TableHead>
            </TableRow>
          </TableHeader>
          <TableBody>
            {stores.map((manifest) => (
              <TableRow className="bg-accent">
                <TableCell>
                  <div className="font-medium">{manifest.name}</div>
                </TableCell>
                <TableCell className="hidden sm:table-cell">
                  <Badge className="text-xs" variant="secondary">
                    Pending
                  </Badge>
                </TableCell>
                <TableCell className="hidden md:table-cell">
                  {manifest.createdAt.toDateString()}
                </TableCell>
                <TableCell className="hidden md:table-cell">
                  <div className="flex gap-2">
                    <Button asChild variant="default">
                      <Link href={`/store/${manifest.slug}`}>Edit</Link>
                    </Button>
                    <DeleteButton
                      action={deleteStoreAction.bind(null, manifest.slug)}
                    />
                  </div>
                </TableCell>
              </TableRow>
            ))}
          </TableBody>
        </Table>
      </CardContent>
    </Card>
  );
}
