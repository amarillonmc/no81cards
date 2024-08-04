--幽之汐雏 灾诞之影
local cm,m=GetID()
function cm.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	--trigger
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,3))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e1:SetCondition(cm.pspcon)
	e1:SetTarget(cm.psptg)
	e1:SetOperation(cm.pspop)
	c:RegisterEffect(e1)
	local e3=e1:Clone()
	e3:SetDescription(aux.Stringid(m,4))
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCondition(aux.TRUE)
	c:RegisterEffect(e3)
	local e5=e1:Clone()
	e5:SetDescription(aux.Stringid(m,5))
	e5:SetCode(EVENT_MOVE)
	e5:SetCondition(cm.pspcon2)
	c:RegisterEffect(e5)
	local e4=e1:Clone()
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e4:SetTarget(cm.psptg2(11451911))
	c:RegisterEffect(e4)
	local e6=e3:Clone()
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e6:SetTarget(cm.psptg2(11451913))
	c:RegisterEffect(e6)
	local e8=e5:Clone()
	e8:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e8:SetTarget(cm.psptg2(11451915))
	c:RegisterEffect(e8)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,2))
	e2:SetCategory(CATEGORY_DRAW+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCondition(cm.spcon)
	e2:SetTarget(cm.sptg)
	e2:SetOperation(cm.spop)
	c:RegisterEffect(e2)
end
function cm.pspcon(e,tp,eg,ep,ev,re,r,rp)
	return re:GetActivateLocation()==LOCATION_HAND
end
function cm.spfilter0(c,loc)
	return c:IsPreviousLocation(loc) and not (c:IsLocation(loc) and c:IsControler(c:GetPreviousControler()))
end
function cm.pspcon2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.spfilter0,1,nil,LOCATION_DECK) and (not eg:IsContains(e:GetHandler()) or e:GetHandler():IsLocation(LOCATION_HAND))
end
function cm.thfilter(c,...)
	local tab={...}
	for _,code in ipairs(tab) do
		if c:GetOriginalCode()==code and c:IsType(TYPE_PENDULUM) and (c:IsFaceup() or not c:IsLocation(LOCATION_MZONE)) then return true end
	end
	return false
end
function cm.psptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local tab0={11451911,11451913,11451915}
	local tab={}
	for _,code in ipairs(tab0) do
		if c:GetFlagEffect(code)>0 then tab[#tab+1]=code end
	end
	if chk==0 then
		return #tab>0 and Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK+LOCATION_MZONE,0,1,nil,e,tp,table.unpack(tab))
	end
	e:SetLabel(table.unpack(tab))
end
function cm.psptg2(code)
	return function(e,tp,eg,ep,ev,re,r,rp,chk)
				local c=e:GetHandler()
				if chk==0 then
					c:RegisterFlagEffect(code,RESET_EVENT+RESETS_STANDARD+RESET_CHAIN,0,1)
					return false
				end
			end
end
function cm.pspop(e,tp,eg,ep,ev,re,r,rp)
	local tab={e:GetLabel()}
	local g=Duel.GetMatchingGroup(cm.thfilter,tp,LOCATION_DECK+LOCATION_MZONE,0,nil,table.unpack(tab))
	if #g==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local sg=g:SelectSubGroup(tp,aux.dncheck,false,1,g:GetClassCount(Card.GetOriginalCode))
	if #sg>0 then
		Duel.SendtoExtraP(sg,nil,REASON_EFFECT)
	end
end
function cm.spfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x9977)
end
function cm.desfilter(c)
	return (c:IsFaceup() or not c:IsOnField()) and c:IsSetCard(0x9977)
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.spfilter,1,nil)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(cm.desfilter,tp,LOCATION_ONFIELD+LOCATION_HAND,0,nil)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) and #g>0 end
	if Duel.GetCurrentChain()>1 then
		e:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CANNOT_DISABLE+0x200)
	else e:SetProperty(EFFECT_FLAG_DELAY) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(cm.desfilter,tp,LOCATION_ONFIELD+LOCATION_HAND,0,nil)
	if #g<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	g=g:Select(tp,1,1,nil)
	if Duel.Destroy(g,REASON_EFFECT)>0 then Duel.Draw(tp,1,REASON_EFFECT) end
end