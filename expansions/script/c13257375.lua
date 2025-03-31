--载史之战士
local m=13257375
local cm=_G["c"..m]
local tokenm=13257374
if not tama then xpcall(function() dofile("expansions/script/tama.lua") end,function() dofile("script/tama.lua") end) end
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,3))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetTarget(cm.sptg)
	e2:SetOperation(cm.spop)
	c:RegisterEffect(e2)
	--[[
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetOperation(cm.regop)
	c:RegisterEffect(e2)
	]]
end
function cm.cfilter(c,tp)
	return not c:IsPublic() and c:IsSetCard(0x351) and bit.band(c:GetType(),TYPE_MONSTER+TYPE_FIELD)>0
end
function cm.thfilter(c)
	return c:IsSetCard(0x351) and c:IsAbleToHand() and bit.band(c:GetType(),TYPE_MONSTER+TYPE_FIELD)>0
end
function cm.thfilter1(c)
	return c:IsSetCard(0x351) and c:IsAbleToHand() and c:IsType(TYPE_FIELD)
end
function cm.thfilter2(c)
	return c:IsSetCard(0x351) and c:IsAbleToHand() and c:IsType(TYPE_MONSTER)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	if chk==0 then return true end
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()==0 then return false end
		e:SetLabel(0)
		return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_HAND,0,2,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local sg=Duel.SelectMatchingCard(tp,cm.cfilter,tp,LOCATION_HAND,0,2,2,nil)
	Duel.ConfirmCards(1-tp,sg)
	Duel.ShuffleHand(tp)
	if sg:IsExists(Card.IsType,1,nil,TYPE_MONSTER) and sg:IsExists(Card.IsType,1,nil,TYPE_FIELD) then
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,sg,sg:GetCount(),0,0)
		Duel.SetChainLimit(aux.FALSE) 
	end
	sg:KeepAlive()
	--[[
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_END)
	e1:SetOperation(function (e,tp,eg,ep,ev,re,r,rp)
		sg:DeleteGroup()
	end)
	e1:SetReset(RESET_EVENT+RESET_CHAIN)
	Duel.RegisterEffect(e1,tp)
	]]
	e:SetLabelObject(sg)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	if g==nil then return end
	local t1=g:IsExists(Card.IsType,1,nil,TYPE_MONSTER)
	local t2=g:IsExists(Card.IsType,1,nil,TYPE_FIELD)
	local sg=Group.CreateGroup()
	if t1 and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
		local g1=Duel.GetMatchingGroup(cm.thfilter1,tp,LOCATION_DECK,0,nil)
		if g1:GetCount()>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			sg:Merge(g1:Select(tp,1,1,nil))
		end
	end
	if t2 and Duel.SelectYesNo(tp,aux.Stringid(m,2)) then
		local g2=Duel.GetMatchingGroup(cm.thfilter2,tp,LOCATION_DECK,0,nil)
		if g2:GetCount()>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			sg:Merge(g2:Select(tp,1,1,nil))
		end
	end
	if sg:GetCount()>0 then
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
	if t1 and t2 then
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end
--[[
function cm.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,3))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetTarget(cm.sptg)
	e1:SetOperation(cm.thop)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1)
end
]]
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,tokenm,0,TYPES_TOKEN_MONSTER,400,400,1,RACE_MACHINE,ATTRIBUTE_DARK,POS_FACEUP,1-tp) then
		local token=Duel.CreateToken(tp,tokenm)
		Duel.SpecialSummon(token,0,tp,1-tp,false,false,POS_FACEUP)
	end
end
