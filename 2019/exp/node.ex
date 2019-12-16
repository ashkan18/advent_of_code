defmodule TreeNode do
  @enforce_keys [:value]
  defstruct left: :leaf, right: :leaf, value: nil
end
