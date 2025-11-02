--狂欢乱流舞者 浮
local s,id,o=GetID()
function s.initial_effect(c)
	Duel.EnableGlobalFlag(GLOBALFLAG_DECK_REVERSE_CHECK)
	--xyz summon
	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,nil,7,2,nil,nil,99)
	
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,id)
	e1:SetCost(s.thcost)
	e1:SetTarget(s.thtg)
	e1:SetOperation(s.thop)
	c:RegisterEffect(e1)
	
	--atk up
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(s.atkval)
	c:RegisterEffect(e2)
	
	--attach from grave or banish
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_LEAVE_GRAVE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,id+o)
	e3:SetTarget(s.attg)
	e3:SetOperation(s.atop)
	c:RegisterEffect(e3)
	if not ConfirmCheck then
		ConfirmCheck=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAIN_END)
		ge1:SetOperation(s.regcon)
		ge1:SetOperation(s.regop)
		Duel.RegisterEffect(ge1,0)
	end
end
-- 连锁结束时检查是否有表侧卡的条件
function s.regcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetMatchingGroupCount(Card.IsPosition,p,LOCATION_DECK,LOCATION_DECK,nil,POS_FACEUP_DEFENSE)>0
end
function s.regop(e,tp,eg,ep,ev,re,r,rp)
	for p=0,1 do
		local g=Duel.GetMatchingGroup(Card.IsPosition,p,LOCATION_DECK,0,nil,POS_FACEUP_DEFENSE)
		local g2=Duel.GetFieldGroup(p,LOCATION_EXTRA,0)
		if #g2>0 then
			Duel.ConfirmCards(p,g+g2,true)
		end
	end
end

function s.mark_as_faceup(c)
	c:ReverseInDeck()
	c:RegisterFlagEffect(id+1000,RESET_EVENT+RESETS_STANDARD,0,1)
end

function s.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end

function s.thfilter(c)
	return c:IsSetCard(0x9225) and c:IsAbleToHand()
end

function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end

function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

function s.atkval(e,c)
	local g=Duel.GetMatchingGroup(Card.IsType,c:GetControler(),LOCATION_ONFIELD,LOCATION_ONFIELD,nil,TYPE_XYZ)
	local atk=0
	for tc in aux.Next(g) do
		atk=atk+tc:GetOverlayCount()
	end
	return atk*200
end

function s.afilter(c)
	return c:IsAbleToChangeControler() and not c:IsType(TYPE_TOKEN)
end

function s.attg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local g1=Duel.GetMatchingGroup(s.afilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
		local g2=Duel.GetMatchingGroup(s.afilter,tp,0,LOCATION_GRAVE+LOCATION_REMOVED,nil)
		return (g1:GetCount()>0 or g2:GetCount()>0)
			and e:GetHandler():IsType(TYPE_XYZ)
	end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,nil,1,0,0)
end

function s.atop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	
	local g1=Duel.GetMatchingGroup(s.afilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
	local g2=Duel.GetMatchingGroup(s.afilter,tp,0,LOCATION_GRAVE+LOCATION_REMOVED,nil)
	local g=Group.CreateGroup()
	if #g1>0 then
		g:Merge(g1)
	end
	if #g2>0 then
		g:Merge(g2)
	end
	
	if #g>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local sg=g:Select(tp,1,2,nil)
		if #sg>0 then
			Duel.Overlay(c,sg)
		end
	end
end