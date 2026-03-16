--究极幻魔 米迦勒
local m=98500040
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:SetUniqueOnField(1,0,m)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCode3(c,6007213,32491822,69890967,cm.mfilter,1,true,true)
	--code
	aux.EnableChangeCode(c,69890967,LOCATION_GRAVE)
	--spsummon condition
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(cm.splimit)
	c:RegisterEffect(e0)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCost(cm.spcost)
	e1:SetTarget(cm.thtg)
	e1:SetOperation(cm.thop)
	c:RegisterEffect(e1)
	--copy effect
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,3))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(3)
	e2:SetCost(cm.copycost)
	e2:SetTarget(cm.copytg)
	e2:SetOperation(cm.copyop)
	c:RegisterEffect(e2)
end
function cm.mfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsLevelAbove(10) and c:IsRace(RACE_FIEND) and c:IsFusionType(TYPE_FUSION)
end
function cm.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION or se:GetHandler():IsCode(89190953) or not e:GetHandler():IsLocation(LOCATION_EXTRA)
end
function cm.check(c,tp)
	return c:IsCode(6007213) and c:IsAbleToDeckAsCost() and Duel.IsExistingMatchingCard(cm.check1,tp,LOCATION_REMOVED,0,1,c,tp,c)
end
function cm.check1(c,tp,tc)
	local cg = Group.FromCards(c,tc)
	return  c:IsCode(32491822) and c:IsAbleToDeckAsCost() and Duel.IsExistingMatchingCard(cm.check2,tp,LOCATION_REMOVED,0,1,cg)
end
function cm.check2(c)
	return c:IsCode(69890967) and c:IsAbleToDeckAsCost()
end
function cm.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.check,tp,LOCATION_REMOVED,0,1,nil,tp) end
	local rg=Group.CreateGroup()
	local tc1 = Duel.SelectMatchingCard(tp,cm.check,tp,LOCATION_REMOVED,0,1,1,nil,tp):GetFirst()
	if tc1 then
		rg:AddCard(tc1)
	end
	local tc2 =Duel.SelectMatchingCard(tp,cm.check1,tp,LOCATION_REMOVED,0,1,1,rg,tp):GetFirst()
	if tc2 then
		rg:AddCard(tc2)
	end
	local tc3 =Duel.SelectMatchingCard(tp,cm.check2,tp,LOCATION_REMOVED,0,1,1,rg):GetFirst()
	if tc3 then
		rg:AddCard(tc3)
	end
	Duel.SendtoDeck(rg,tp,2,REASON_COST)
end
function cm.thfilter(c)
	return (aux.IsCodeListed(c,6007213) or aux.IsCodeListed(c,32491822) or aux.IsCodeListed(c,69890967)) and c:IsAbleToHand()
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function cm.check3(c,tp,tc)
	return (c:IsCode(6007213,32491822,69890967)
		or ((aux.IsCodeListed(c,6007213) or aux.IsCodeListed(c,32491822) or aux.IsCodeListed(c,69890967)) or (c:IsSetCard(0x144))
		and c:IsLevelAbove(10) and not c:IsCode(m))) and tc:GetFlagEffect(c:GetOriginalCodeRule())==0 and not Duel.IsExistingMatchingCard(cm.check4,tp,LOCATION_ONFIELD,0,1,nil,c)
end
function cm.check4(c,tc)
	return c:IsFaceup() and c:IsCode(tc:GetCode())
end
function cm.copycost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(cm.check3,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_EXTRA,0,1,nil,tp,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local sg=Duel.SelectMatchingCard(tp,cm.check3,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_EXTRA,0,1,1,nil,tp,c)
	Duel.ConfirmCards(1-tp,sg)
	local tc=sg:GetFirst()
	local code = tc:GetOriginalCodeRule()
	e:SetLabel(code)
	c:RegisterFlagEffect(code,RESET_PHASE+PHASE_STANDBY+RESET_EVENT+RESETS_STANDARD,0,1)
end
function cm.copytg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetChainLimit(aux.FALSE)
end
function cm.copyop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local code=e:GetLabel()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local cid=0
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_CHANGE_CODE)
		e1:SetValue(code)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_STANDBY)
		c:RegisterEffect(e1)
		cid=c:CopyEffect(code,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_STANDBY,1)
		local e3=Effect.CreateEffect(c)
		e3:SetDescription(aux.Stringid(m,2))
		e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e3:SetCode(EVENT_PHASE+PHASE_STANDBY)
		e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e3:SetCountLimit(1)
		e3:SetRange(LOCATION_MZONE)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_STANDBY)
		e3:SetLabelObject(e1)
		e3:SetLabel(cid)
		e3:SetOperation(cm.rstop)
		c:RegisterEffect(e3)
	end
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_PIERCE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetReset(RESET_PHASE+PHASE_STANDBY)
	Duel.RegisterEffect(e2,tp)
	e:SetLabel(0)
end
function cm.rstop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local cid=e:GetLabel()
	if cid~=0 then
		c:ResetEffect(cid,RESET_COPY)
		c:ResetEffect(RESET_DISABLE,RESET_EVENT)
	end
	local e1=e:GetLabelObject()
	e1:Reset()
	Duel.HintSelection(Group.FromCards(c))
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end