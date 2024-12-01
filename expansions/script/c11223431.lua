local m=11223431
local cm=_G["c"..m]
cm.name="恒斗神 - 烈爪"
function cm.initial_effect(c)
	c:EnableReviveLimit()
	--Fusion Material
	aux.AddFusionProcFunRep(c,cm.ffilter,2,false)
	--Extra Effect
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_SPSUMMON_SUCCESS)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCondition(cm.con)
	e0:SetOperation(cm.op)
	c:RegisterEffect(e0)
	--Special Summon Condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(cm.splimit)
	c:RegisterEffect(e1)
	--Special Summon Rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(cm.spcon)
	e2:SetOperation(cm.spop)
	e2:SetLabelObject(e0)
	c:RegisterEffect(e2)
	--Material Check
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_MATERIAL_CHECK)
	e3:SetValue(cm.valcheck)
	e3:SetLabelObject(e0)
	c:RegisterEffect(e3)
	--Destroy
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,2))
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,m)
	e4:SetCost(cm.cost)
	e4:SetTarget(cm.target)
	e4:SetOperation(cm.operation)
	c:RegisterEffect(e4)
	
end
--Fusion Material
function cm.ffilter(c)
	return c:IsFusionAttribute(ATTRIBUTE_DARK) and c:IsRace(RACE_WARRIOR)
end
--Spsummon Condition
function cm.splimit(e,se,sp,st)
	return not e:GetHandler():IsLocation(LOCATION_EXTRA) or bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
--Special Summon Rule
function cm.spfilter(c)
	return c:GetOriginalAttribute()==ATTRIBUTE_DARK and c:GetOriginalRace()==RACE_WARRIOR
		and c:IsAbleToRemoveAsCost()
end
function cm.spfilter1(c,tp)
	return cm.spfilter(c) and Duel.IsExistingMatchingCard(cm.spfilter2,tp,LOCATION_ONFIELD,0,1,c,tp,c)
end
function cm.spfilter2(c,tp,mc)
	return cm.spfilter(c) and Duel.GetLocationCountFromEx(tp,tp,Group.FromCards(c,mc))>0
end
function cm.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.IsExistingMatchingCard(cm.spfilter1,tp,LOCATION_ONFIELD,0,1,nil,tp)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local mat1=Duel.SelectMatchingCard(tp,cm.spfilter1,tp,LOCATION_ONFIELD,0,1,1,nil,tp)
	local mat2=Duel.SelectMatchingCard(tp,cm.spfilter2,tp,LOCATION_ONFIELD,0,1,1,mat1:GetFirst(),tp,mat1:GetFirst())
	mat1:Merge(mat2)
	if mat1:IsExists(cm.cfilter,1,nil) then
		e:GetLabelObject():SetLabel(1)
	end
	e:GetHandler():SetMaterial(mat1)
	Duel.Remove(mat1,POS_FACEUP,REASON_COST+REASON_MATERIAL+REASON_FUSION)
end
--Material Check
function cm.cfilter(c)
	return c:GetBaseAttack()==500 and c:GetBaseDefense()==500
end
function cm.valcheck(e,c)
	if c:GetMaterial():IsExists(cm.cfilter,1,nil) then
		e:GetLabelObject():SetLabel(1)
	end
end
--Copy
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetLabel()==1
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	e:SetLabel(0)
	local c=e:GetHandler()
	if c:IsFaceup() then
		--Copy
		local e0=Effect.CreateEffect(c)
		e0:SetDescription(aux.Stringid(m,0))
		e0:SetCategory(CATEGORY_TOHAND)
		e0:SetType(EFFECT_TYPE_IGNITION)
		e0:SetRange(LOCATION_MZONE)
		e0:SetCountLimit(1)
		e0:SetCost(cm.copycost)
		e0:SetTarget(cm.copytg)
		e0:SetOperation(cm.copyop)
		e0:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e0)
	end
end
function cm.copyfilter(c)
	return c:IsFaceup() and c:GetBaseAttack()==500 and c:IsAbleToHand()
end
function cm.copycost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,500) end
	Duel.PayLPCost(tp,500)
end
function cm.copytg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.copyfilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,nil) end
	local g=Duel.GetMatchingGroup(cm.copyfilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function cm.copyop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tg=Duel.SelectMatchingCard(tp,cm.copyfilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,1,nil)
	local tc=tg:GetFirst()
	if tc and Duel.SendtoHand(tc,tp,REASON_EFFECT)~=0 then
		Duel.ConfirmCards(1-tp,tc)
		local c=e:GetHandler()
		local code=tc:GetOriginalCode()
		local cid=c:CopyEffect(code,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,1)
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(m,1))
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCountLimit(1)
		e1:SetOperation(cm.rstop)
		e1:SetLabel(cid)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	end
end
function cm.rstop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local cid=e:GetLabel()
	c:ResetEffect(cid,RESET_COPY)
	Duel.HintSelection(Group.FromCards(c))
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
--Destroy
function cm.costfilter(c)
	return c:GetAttack()==500 and c:GetDefense()==500 and c:IsAbleToRemoveAsCost()
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetMatchingGroupCount(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if ct>2 then ct=2 end
	if chk==0 then return Duel.IsExistingMatchingCard(cm.costfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,cm.costfilter,tp,LOCATION_GRAVE,0,1,ct,nil)
	e:SetLabel(g:GetCount())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	local ct=e:GetLabel() or 0
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,ct,0,0)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local ct=e:GetLabel() or 0
	if ct==0 then return end
	local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,ct,ct,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.Destroy(g,REASON_EFFECT)
	end
end