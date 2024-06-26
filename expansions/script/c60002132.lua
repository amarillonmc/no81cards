--【日】圣辉女剑士
local m=60002132
local cm=_G["c"..m]
cm.name="【日】圣辉女剑士"
cm.dfc_front_side=m+1
function cm.initial_effect(c)
	--爆能强化
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,0))
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetCode(EFFECT_SUMMON_PROC)
	e3:SetCondition(cm.sumcon)
	e3:SetOperation(cm.sumop)
	e3:SetValue(SUMMON_TYPE_ADVANCE)
	c:RegisterEffect(e3)
	--进化
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,0))  
	e4:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e4:SetType(EFFECT_TYPE_IGNITION) 
	e4:SetRange(LOCATION_MZONE)  
	e4:SetCost(cm.drcost) 
	e4:SetOperation(cm.drop)
	c:RegisterEffect(e4)  
end
function cm.cfilter(c,tp)
	return (c:IsControler(tp) or c:IsFaceup())
end
function cm.sumcon(e,c,minc)
	if c==nil then return true end
	local min=1
	if minc>=1 then min=minc end
	local tp=c:GetControler()
	local mg=Duel.GetMatchingGroup(cm.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,tp)
	return c:IsLevelAbove(5) and Duel.CheckTribute(c,min,10,mg)
end
function cm.sumop(e,tp,eg,ep,ev,re,r,rp,c,minc)
	local min=1
	if minc>=1 then min=minc end
	local mg=Duel.GetMatchingGroup(cm.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,tp)
	local sg=Duel.SelectTribute(tp,c,min,10,mg)
	c:SetMaterial(sg)
	Duel.Release(sg,REASON_SUMMON+REASON_MATERIAL)
end
function cm.mgfilter(c,e,tp,fusc)
	return bit.band(c:GetReason(),0x12)==0x12 and c:GetReasonCard()==fusc
		and (c:IsAbleToDeckAsCost() or c:IsAbleToExtraAsCost())  
end
function cm.mgfilter2(c,e,tp,fusc)
	return not c:IsDisabled() and c:IsAbleToDeck() and c:IsCode(1231611)
end
function cm.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local ag=c:GetMaterial()
	if chk==0 then return (ag and ag:GetCount()>0 and ag:IsExists(cm.mgfilter,2,nil,e,tp,c))
		or Duel.IsExistingMatchingCard(cm.mgfilter2,tp,LOCATION_GRAVE,0,2,nil) end
	if not (ag and ag:GetCount()>0 and ag:IsExists(cm.mgfilter,2,nil,e,tp,c)) then 
		local g=Duel.SelectMatchingCard(tp,cm.mgfilter2,tp,LOCATION_GRAVE,0,2,2,nil) 
		Duel.SendtoDeck(g,nil,2,REASON_COST)
		return 
	end 
	if Duel.IsExistingMatchingCard(cm.mgfilter2,tp,LOCATION_GRAVE,0,2,nil) 
		and Duel.SelectYesNo(tp,aux.Stringid(m,5)) then 
		local g=Duel.SelectMatchingCard(tp,cm.mgfilter2,tp,LOCATION_GRAVE,0,2,2,nil) 
		Duel.SendtoDeck(g,nil,2,REASON_COST)
		return 
	end 
	local dc=ag:FilterSelect(tp,cm.mgfilter,2,2,nil,e,tp,c)
	Duel.SendtoDeck(dc,nil,2,REASON_COST)
end
function cm.drop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	local g1=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_MZONE,0,nil)
	local g2=Duel.GetMatchingGroupCount(aux.TRUE,tp,LOCATION_MZONE,0,nil)
	for i=1,g2 do
		local gm=g1:GetFirst():GetCode()
		if gm==60001234 and Senya.IsDFCTransformable(gm) and c:IsFaceup() then
			Senya.TransformDFCCard(gm)
			Debug.Message("超越天的意志！")
		else
			if c:IsFaceup() then 
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_SET_BASE_ATTACK)
				e1:SetValue(1000)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
				c:RegisterEffect(e1)
				local e2=Effect.CreateEffect(c)
				e2:SetType(EFFECT_TYPE_SINGLE)
				e2:SetCode(EFFECT_SET_BASE_DEFENSE)
				e2:SetValue(1000)
				e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
				c:RegisterEffect(e2) 
			end 
		end
		g:RemoveCard(g:GetFirst())
	end
	Duel.RegisterFlagEffect(tp,60001234,RESET_PHASE+PHASE_END,0,1000)
end