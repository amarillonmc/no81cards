--惊乐园的迎接人 <G双子>
local s,id=GetID()
function s.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,nil,2,2,s.lcheck)
	c:EnableReviveLimit()
	c:SetSPSummonOnce(id)
	--extra material
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EFFECT_EXTRA_LINK_MATERIAL)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetTargetRange(0,LOCATION_MZONE)
	e1:SetTarget(s.mattg)
	e1:SetValue(s.matval)
	c:RegisterEffect(e1)
	--activated in hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1) 
	e2:SetTargetRange(LOCATION_HAND,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x15c))
	c:RegisterEffect(e2)
	--tograve
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_DECKDES+CATEGORY_GRAVE_ACTION+CATEGORY_TOHAND)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,id)
	e3:SetTarget(s.distg)
	e3:SetOperation(s.disop)
	c:RegisterEffect(e3)	
end
function s.lcheck(g)
	return g:IsExists(Card.IsSetCard,1,nil,0x15b)
end
function s.eqfilter(c)
	return c:IsType(TYPE_TRAP) and c:IsSetCard(0x15c)
end
function s.mattg(e,c)
	local g=c:GetEquipGroup()
	return g and g:IsExists(s.eqfilter,1,nil,tp)
end
function s.exmatcheck(c,lc,tp)
	if not c:IsControler(1-tp) then return false end
	local le={c:IsHasEffect(EFFECT_EXTRA_LINK_MATERIAL,tp)}
	for _,te in pairs(le) do
		local f=te:GetValue()
		local related,valid=f(te,lc,nil,c,tp)
		if related and not te:GetHandler():IsCode(id) then return false end
	end
	return true
end

function s.matval(e,lc,mg,c,tp)
	if e:GetHandler()~=lc then return false,nil end
	return true,not mg or not mg:IsExists(s.exmatcheck,1,nil,lc,tp)
end
function s.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function s.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetMatchingGroupCount(s.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	local dg=Duel.GetDecktopGroup(tp,ct)
	if chk==0 then return ct>0 and dg:FilterCount(Card.IsAbleToGrave,nil,tp)==ct
		and dg:FilterCount(Card.IsAbleToDeck,nil)==ct end
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,ct)
end
function s.thfilter(c)
	if not (c:IsLocation(LOCATION_GRAVE) and c:IsAbleToHand()) or c:IsHasEffect(EFFECT_NECRO_VALLEY) then return false end
	return (c:IsType(TYPE_MONSTER) and c:IsSetCard(0x15b)) or (c:IsType(TYPE_TRAP) and c:IsSetCard(0x15c))
end
function s.disop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local ct=Duel.GetMatchingGroupCount(s.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if not Duel.DiscardDeck(p,ct,REASON_EFFECT)==ct then return end 
	local g=Duel.GetOperatedGroup()
	local sg=g:Filter(s.thfilter,nil)
	if #sg>0 and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local tg=sg:Select(tp,1,1,nil)
		Duel.SendtoHand(tg,tp,REASON_EFFECT)
	end
end