--战械人形·粉碎者
local m=29065620
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	c:SetSPSummonOnce(m)
	aux.AddXyzProcedureLevelFree(c,cm.mfilter,aux.TRUE,2,2)
	--remove
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,0))
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(cm.rmcon)
	e3:SetTarget(cm.rmtg)
	e3:SetOperation(cm.rmop)
	c:RegisterEffect(e3)
	if not cm.global_check then
		cm.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_REMOVE)
		ge1:SetOperation(cm.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=ge1:Clone()
		ge2:SetCode(EVENT_CHAINING)
		ge2:SetLabelObject(ge1)
		ge2:SetOperation(cm.reset)
		Duel.RegisterEffect(ge2,0)
	end
end
function cm.checkop(e,tp,eg,ep,ev,re,r,rp)
	for tc in aux.Next(eg) do
		if tc:IsReason(REASON_COST) and re:IsActivated() then
			Duel.RegisterFlagEffect(0,m,0,0,0)
			local loc,p=tc:GetPreviousLocation(),tc:GetPreviousControler()
			local i=Duel.GetFlagEffect(0,m)*2-2
			cm[i]=loc
			cm[i+1]=p
			cm[i+2]=114
			e:SetLabelObject(re)
		end
	end
end
function cm.reset(e,tp,eg,ep,ev,re,r,rp)
	local ace=e:GetLabelObject():GetLabelObject()
	if ace and re~=ace then Duel.ResetFlagEffect(0,m) end
end
--
function cm.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(0,m)>0
end
function cm.cfilter(c,tp)
	return c:IsFaceup() and c:IsRace(RACE_MACHINE) and c:IsType(TYPE_XYZ)
end
function cm.refilter(c,tp)
	return c:IsAbleToRemove(tp,POS_FACEUP,REASON_EFFECT)
end
function cm.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(cm.cfilter,tp,LOCATION_MZONE,0,nil)
	local og=Group.CreateGroup()
	for tc in aux.Next(g) do
	local tg=tc:GetOverlayGroup()
	og:Merge(tg)
	end
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,nil) and og:FilterCount(cm.refilter,nil,tp)>1 end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,1-tp,LOCATION_ONFIELD)
end
function cm.rmop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.cfilter,tp,LOCATION_MZONE,0,nil)
	local og=Group.CreateGroup()
	for tc in aux.Next(g) do
	local tg=tc:GetOverlayGroup()
	og:Merge(tg)
	end
	local g1=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,nil)
	if g1:GetCount()>0 and og:FilterCount(cm.refilter,nil,tp)>1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local sg1=og:FilterSelect(tp,cm.refilter,2,2,nil,tp)
		local sg=g1:Select(tp,1,1,nil)
		local sg2=sg+sg1
		Duel.HintSelection(sg)
		Duel.Remove(sg2,POS_FACEUP,REASON_EFFECT)
	end
end
--
function cm.mfilter(c,xyzc)
	return c:IsSetCard(0x87ad) and not c:IsSummonableCard()
end