--机装重组
local m=60001098
local cm=_G["c"..m]
if not pcall(function() require("expansions/script/c60000101") end) then require("script/c60000101") end
function cm.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m)
	e1:SetTarget(cm.tg)
	e1:SetOperation(cm.op)
	c:RegisterEffect(e1)
	--Destroy
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,160001098)
	e2:SetCondition(jkz.xcon)
	e2:SetCost(cm.descost)
	e2:SetOperation(cm.immop)
	c:RegisterEffect(e2)
	local ge1 = jkz.GetCountEffect(c)
end
cm.named_with_ExMachina=true
function cm.tgfilter(c,e,tp)
	return c:IsFaceup() and c.named_with_ExMachina and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave() and 
	Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp,c:GetCode()) and 
	(not (c:GetSequence()>4) or Duel.GetLocationCount(tp,LOCATION_MZONE)>0)
end

function cm.spfilter(c,e,tp,code)
	return c.named_with_ExMachina and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsCode(code)
end

function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and cm.tgfilter(chkc) end
	if chk==0 then return Duel.IsExistingMatchingCard(cm.tgfilter,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,cm.tgfilter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end

function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SendtoGrave(tc,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_GRAVE)
	and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,tc:GetCode())
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end

function cm.namedfilter(c)
	return c.named_with_ExMachina
end

function cm.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetFieldGroup(tp,LOCATION_DECK,0)
	Duel.ConfirmCards(1-tp,g)
	if not Duel.IsExistingMatchingCard(cm.namedfilter,tp,LOCATION_DECK,0,1,nil) then 
		e:SetLabel(1)
	end
end

function cm.immop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==1 then
		local e5=Effect.CreateEffect(e:GetHandler())
		e5:SetType(EFFECT_TYPE_FIELD)
		e5:SetCode(EFFECT_CANNOT_DISEFFECT)
		e5:SetValue(cm.effectfilter)
		Duel.RegisterEffect(e5,tp)
	end
end

function cm.effectfilter(e,ct)
	local p=e:GetHandler():GetControler()
	local te,tp,loc=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER,CHAININFO_TRIGGERING_LOCATION)
	return p==tp and te:GetHandler().named_with_ExMachina and bit.band(loc,LOCATION_ONFIELD)~=0
end