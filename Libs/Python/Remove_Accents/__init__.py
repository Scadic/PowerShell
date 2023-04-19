from unicodedata import normalize, category

def remove_accents(string):
    """
    Removes accents from `string`\n
    Parameters:\n
    :string (str): string to remove accents from.\n
    remove_accents(`string`) -> str
    """
    return ''.join(( c for c in normalize('NFD', string) if category(c) != 'Mn' ))