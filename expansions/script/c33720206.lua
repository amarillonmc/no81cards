--[[
花花变身·动物朋友 朱雀
H-Anifriends Suzaku
Card Author: nemoma
Scripted by: XGlitchy30
]]
local s,id=GetID()
if not GLITCHYLIB_LOADED then
	Duel.LoadScript("glitchylib_vsnemo.lua")
end
function s.initial_effect(c)
	--fusion material
	aux.AddFusionProcFunRep(c,s.ffilter,2,true)
	aux.AddContactFusionProcedureGlitchy(c,aux.Stringid(id,0),false,0,Card.IsAbleToGraveAsCost,LOCATION_MZONE,0,nil,aux.ContactFusionMaterialsToGrave)
	c:EnableReviveLimit()
	--This card's name becomes "Anifriends Suzaku of the South" while on the field or in the GY.
	aux.EnableChangeCode(c,33700083,LOCATION_MZONE|LOCATION_GRAVE)
	--During your Main Phase: You can shuffle 3 or more cards from your GY to your Deck, but all must have the same Type, Attribute, ATK or DEF, and if you do, add up to 3 cards with the same respective value from your Deck to your hand. If you add multiple cards to your hand with this effect, they must have the same name.
	local e1=Effect.CreateEffect(c)
	e1:Desc(1,id)
	e1:SetCategory(CATEGORIES_SEARCH|CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:HOPT()
	e1:SetFunctions(nil,nil,s.target,s.operation)
	c:RegisterEffect(e1)
	if not aux.H_Anifriends_flist then
		aux.H_Anifriends_flist={Card.GetRace,Card.GetAttribute,Card.GetTextAttack,Card.GetTextDefense}
	end
	if not s.flist then
		s.flist={Card.IsRace,Card.IsAttribute,Card.IsTextAttack,Card.IsTextDefense}
	end
end
function s.ffilter(c,fc,sub,mg,sg)
	if not mg or #mg~=2 then return true end
	return not mg:IsExists(aux.NOT(Card.IsFusionSetCard),1,nil,ARCHE_ANIFRIENDS) or (mg:GetClassCount(Card.GetFusionCode)==1 and mg:GetClassCount(Card.GetAttack)==2 and mg:GetClassCount(Card.GetDefense)==2)
end

--E1
function s.filter(c)
	return c:IsMonster() and c:IsAbleToDeck()
end
function s.thfilter(c)
	return c:IsMonster() and c:IsAbleToHand()
end
function s.rescon(chk)
	return	function(g,e,tp,mg,c)
				local delete=0
				for i,f in ipairs(aux.H_Anifriends_flist) do
					local ok=true
					if chk and not Duel.IsExists(false,s.flist[i],tp,LOCATION_DECK,0,1,nil,f(c)) then
						ok=false
						delete=delete+1
					end
					if g:GetClassCount(f)==1 and ok then
						return true
					end
				end
				return false, chk and delete==4 
			end
end
function s.threscon(g)
	if g:GetClassCount(Card.GetCode)>1 then return false end
	for _,f in ipairs(aux.H_Anifriends_flist) do
		if g:GetClassCount(f)==1 then
			return true
		end
	end
	return false
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local g=Duel.Group(s.filter,tp,LOCATION_GRAVE,0,nil)
		return aux.SelectUnselectGroup(g,e,tp,3,#g,s.rescon(true),0)
	end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,3,tp,LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.Group(aux.Necro(s.filter),tp,LOCATION_GRAVE,0,nil)
	if #g<=0 then return end
	local sg=aux.SelectUnselectGroup(g,e,tp,3,#g,s.rescon(true),1,tp,HINTMSG_OPERATECARD,s.rescon(false))
	if not sg or #sg==0 then
		sg=aux.SelectUnselectGroup(g,e,tp,3,#g,s.rescon(false),1,tp,HINTMSG_OPERATECARD,s.rescon(false))
	end
	if #sg>0 then
		local cg=sg:Clone()
		local validg=Group.CreateGroup()
		local tg=Duel.Group(s.thfilter,tp,LOCATION_DECK,0,nil)
		for tc in aux.Next(tg) do
			cg:AddCard(tc)
			for i,f in ipairs(aux.H_Anifriends_flist) do
				if cg:GetClassCount(f)==1 then
					validg:AddCard(tc)
				end
			end
			cg:RemoveCard(tc)
		end
		Duel.HintSelection(sg)
		if Duel.ShuffleIntoDeck(sg)>=3 then
			local sg2=aux.SelectUnselectGroup(validg,e,tp,1,3,s.threscon,1,tp,HINTMSG_ATOHAND,s.threscon)
			if #sg2>0 then
				Duel.Search(sg2,tp)
			end
		end
	end
end