--幽玄龙象※乾御埃天
--21.07.25
local cm,m=GetID()
function cm.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,3))
	e1:SetCategory(CATEGORY_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_TO_HAND)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(cm.spcon)
	e1:SetTarget(cm.sumtg)
	e1:SetOperation(cm.sumop)
	c:RegisterEffect(e1)
	cm.hand_effect=cm.hand_effect or {}
	cm.hand_effect[c]=e1
	--limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,m)
	e2:SetCondition(cm.cacon)
	e2:SetTarget(cm.catg)
	e2:SetOperation(cm.caop)
	c:RegisterEffect(e2)
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsControler,1,nil,tp)
end
function cm.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.smfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function cm.smfilter(c,ec)
	if not c:IsSetCard(0x3978) and c~=ec then return false end
	local e1,e2=Effect.CreateEffect(ec),Effect.CreateEffect(ec)
	local mi,ma=c:GetTributeRequirement()
	--summon
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SUMMON_PROC)
	e1:SetCondition(cm.ttcon)
	if mi>0 then e1:SetValue(SUMMON_TYPE_ADVANCE) end
	c:RegisterEffect(e1,true)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_SET_PROC)
	e2:SetCondition(cm.ttcon)
	c:RegisterEffect(e2,true)
	local res1,res2=c:IsSummonable(true,nil),c:IsMSetable(true,nil)
	e1:Reset()
	e2:Reset()
	return (res1 or res2),res1,res2
end
function cm.cpfilter(c)
	return c:GetOriginalType()&TYPE_LINK==0
end
function cm.fselect(g,tp)
	local dg=g:Filter(Card.IsFacedown,nil)
	return g:GetClassCount(Card.GetPosition)==2 and (#dg>0 or not (g-dg):IsExists(function(c) return c:IsFaceup() and not c:IsCanTurnSet() end,1,nil))
end
function cm.ttcon(e,c,minc)
	if c==nil then return true end
	local tp=c:GetControler()
	local mi,ma=c:GetTributeRequirement()
	local g=Duel.GetMatchingGroup(cm.cpfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	return ma>0 and Duel.GetMZoneCount(tp)>0 and g:CheckSubGroup(cm.fselect,2,2,tp)
end
function cm.ttop(e,tp,eg,ep,ev,re,r,rp,c)
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(cm.cpfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	local sg=g:SelectSubGroup(tp,cm.fselect,false,2,2,tp)
	local tc=sg:GetFirst()
	local tc2=sg:GetNext()
	local pos=tc:GetPosition()
	Duel.ChangePosition(tc,tc2:GetPosition())
	Duel.ChangePosition(tc2,pos)
	c:SetMaterial(nil)
end
function cm.sumop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.smfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil,c)
	local tc=g:GetFirst()
	if tc then
		local _,s1,s2=cm.smfilter(tc,c)
		if tc:IsLocation(LOCATION_HAND) then
			local mi,ma=c:GetTributeRequirement()
			local e1=Effect.CreateEffect(c)
			e1:SetDescription(aux.Stringid(m,4))
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_SUMMON_PROC)
			e1:SetCondition(cm.ttcon)
			e1:SetOperation(cm.ttop)
			if mi>0 then e1:SetValue(SUMMON_TYPE_ADVANCE) end
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1,true)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_SET_PROC)
			tc:RegisterEffect(e2,true)
		end
		if (s1 and s2 and Duel.SelectPosition(tp,tc,POS_FACEUP_ATTACK+POS_FACEDOWN_DEFENSE)==POS_FACEUP_ATTACK) or not s2 then
			Duel.Summon(tp,tc,true,nil)
		else
			Duel.MSet(tp,tc,true,nil)
		end
	end
end
function cm.cacon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousPosition(POS_FACEDOWN) and e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD) and aux.bpcon()
end
function cm.catg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local seq=e:GetHandler():GetPreviousSequence()
	if e:GetHandler():GetPreviousControler()==1-tp then seq=4-seq end
	e:SetLabel(seq)
	local fd=1<<seq
	Duel.Hint(HINT_ZONE,tp,fd)
	Duel.Hint(HINT_ZONE,1-tp,fd<<16)
end
function cm.clfilter(c,tp,seq)
	return aux.GetColumn(c,tp)==seq
end
function cm.caop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_ONLY_ATTACK_MONSTER)
	e1:SetTargetRange(0,LOCATION_MZONE)
	e1:SetValue(cm.atklimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local seq=e:GetLabel()
	if Duel.GetMatchingGroupCount(cm.clfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,tp,seq)>0 then
		Duel.Hint(HINT_OPSELECTED,tp,aux.Stringid(m,2))
		Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(m,2))
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_CHAIN_SOLVED)
		e2:SetOperation(cm.drop)
		e2:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e2,tp)
	end
end
function cm.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_CONTROLER,CHAININFO_TRIGGERING_LOCATION)
	if not re:IsActiveType(TYPE_MONSTER) or p==tp or loc&LOCATION_MZONE==0 or re:GetHandler():GetAttackedCount()>0 then return end
	Duel.Draw(tp,1,REASON_EFFECT)
end
function cm.atklimit(e,c)
	return c:IsFacedown()
end