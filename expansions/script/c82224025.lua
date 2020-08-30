local m=82224025
local cm=_G["c"..m]
cm.name="未来机甲 托雷戴尔"
function cm.initial_effect(c)
	--link summon  
	aux.AddLinkProcedure(c,nil,2,99)  
	c:EnableReviveLimit()  
	--splimit  
	local e0=Effect.CreateEffect(c)  
	e0:SetType(EFFECT_TYPE_SINGLE)  
	e0:SetCode(EFFECT_SPSUMMON_COST)  
	e0:SetCost(cm.spcost)  
	c:RegisterEffect(e0)
	--to grave
	local e1=Effect.CreateEffect(c)  
	e1:SetDescription(aux.Stringid(m,0)) 
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)  
	e1:SetProperty(EFFECT_FLAG_DELAY)  
	e1:SetCode(EVENT_SPSUMMON_SUCCESS) 
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_DUEL)
	e1:SetCost(cm.cost)
	e1:SetCondition(cm.con)  
	e1:SetTarget(cm.tg)  
	e1:SetOperation(cm.op)  
	c:RegisterEffect(e1) 
end
function cm.spcost(e,c,tp,st)  
	if bit.band(st,SUMMON_TYPE_LINK)~=SUMMON_TYPE_LINK then return true end  
	return Duel.GetTurnPlayer()==tp and (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2)
end  
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return true end  
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))  
end  
function cm.con(e,tp,eg,ep,ev,re,r,rp)  
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)  
end  
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)  
	local g=Duel.GetFieldGroup(tp,0,LOCATION_MZONE)  
	if chk==0 then return g:GetCount()>0 end  
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)   
end  
function cm.op(e,tp,eg,ep,ev,re,r,rp)  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)  
	local tc=Duel.SelectMatchingCard(tp,nil,tp,0,LOCATION_MZONE,1,1,nil):GetFirst()  
	if tc and Duel.SendtoGrave(tc,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_GRAVE) then  
		local c=e:GetHandler()  
		local e1=Effect.CreateEffect(c)  
		e1:SetType(EFFECT_TYPE_FIELD)  
		e1:SetCode(EFFECT_DISABLE)  
		e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)  
		e1:SetTarget(cm.distg)  
		e1:SetLabelObject(tc)   
		Duel.RegisterEffect(e1,tp)  
		local e2=Effect.CreateEffect(c)  
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)  
		e2:SetCode(EVENT_CHAIN_SOLVING)  
		e2:SetCondition(cm.discon)  
		e2:SetOperation(cm.disop)  
		e2:SetLabelObject(tc)   
		Duel.RegisterEffect(e2,tp)   
	end  
end  
function cm.distg(e,c)  
	local tc=e:GetLabelObject()  
	return c:IsOriginalCodeRule(tc:GetOriginalCodeRule())  
end  
function cm.discon(e,tp,eg,ep,ev,re,r,rp)  
	local tc=e:GetLabelObject()  
	return re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsOriginalCodeRule(tc:GetOriginalCodeRule())  
end  
function cm.disop(e,tp,eg,ep,ev,re,r,rp)  
	Duel.NegateEffect(ev)  
end  