--幻想时间 白枭骑士
local m=21192025
local cm=_G["c"..m]
local setcard=0x3917
function cm.initial_effect(c)
	c:EnableReviveLimit()
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(1164)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(cm.syscon(cm.x,aux.NonTuner(cm.x),1,6))
	e0:SetTarget(cm.systg(cm.x,aux.NonTuner(cm.x),1,6))
	e0:SetOperation(aux.SynOperation(cm.x,aux.NonTuner(cm.x),1,6))
	e0:SetValue(SUMMON_TYPE_SYNCHRO)
	c:RegisterEffect(e0) 
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1)
	e1:SetCondition(cm.con)
	e1:SetTarget(cm.tg)
	e1:SetOperation(cm.op)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_GRAVE_SPSUMMON+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,m)
	e2:SetCondition(cm.con2)
	e2:SetTarget(cm.tg2)
	e2:SetOperation(cm.op2)
	c:RegisterEffect(e2)
end
function cm.x(c)
	return c:IsSetCard(setcard)
end
function cm.q(c,sc)
	return c:IsCanBeSynchroMaterial(sc) and c:IsFaceup() and c:IsSetCard(setcard)
end
function cm.syscon(f1,f2,minc,maxc)
	return  function(e,c,smat,mg,min,max)
				if c==nil then return true end
				if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
				local minc=minc
				local maxc=maxc
				if min then
					if min>minc then minc=min end
					if max<maxc then maxc=max end
					if minc>maxc then return false end
				end 
				if mg==nil then 
					mg=Duel.GetMatchingGroup(cm.q,c:GetControler(),12,0,nil,c) 
				end 
				if smat and smat:IsTuner(c) and (not f1 or f1(smat)) then
					return Duel.CheckTunerMaterial(c,smat,f1,f2,minc,maxc,mg) end
				return Duel.CheckSynchroMaterial(c,f1,f2,minc,maxc,smat,mg)
			end
end
function cm.systg(f1,f2,minc,maxc)
	return  function(e,tp,eg,ep,ev,re,r,rp,chk,c,smat,mg,min,max)
				local minc=minc
				local maxc=maxc
				if min then
					if min>minc then minc=min end
					if max<maxc then maxc=max end
					if minc>maxc then return false end
				end
				if mg==nil then 
					mg=Duel.GetMatchingGroup(cm.q,c:GetControler(),12,0,nil,c) 
				end 
				local g=nil 
				if smat and smat:IsTuner(c) and (not f1 or f1(smat)) then
					g=Duel.SelectTunerMaterial(c:GetControler(),c,smat,f1,f2,minc,maxc,mg)
				else
					g=Duel.SelectSynchroMaterial(c:GetControler(),c,f1,f2,minc,maxc,smat,mg)
				end
				if g then
					g:KeepAlive()
					e:SetLabelObject(g)
					return true
				else return false end
			end
end
function cm.w(c,tp)
	return c:IsSetCard(setcard) and c:IsControler(tp)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.w,1,nil,tp)
end
function cm.e(c)
	return c:IsFaceup() 
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(cm.e,tp,4,4,1,nil) end
	Duel.Hint(3,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,cm.e,tp,4,4,1,1,nil)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and not c:IsImmuneToEffect(e) then
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(-500)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	tc:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	tc:RegisterEffect(e2)
		if not tc:IsHasEffect(108) and tc:IsReleasableByEffect() and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
		Duel.BreakEffect()
		Duel.Release(tc,REASON_EFFECT)
		end		
	end
end
function cm.con2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_SYNCHRO) and c:IsPreviousLocation(LOCATION_MZONE) and c:IsPreviousControler(tp) and c:GetReasonPlayer()==1-tp and c:IsReason(REASON_EFFECT)
end
function cm.r(c,e,tp)
	return c:IsSetCard(setcard) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,4)>0
end
function cm.t(c)
	return c:IsSetCard(setcard) and c:IsType(1) and Duel.GetLocationCount(tp,8)>0 and not c:IsForbidden()
end
function cm.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.GetMatchingGroup(cm.r,tp,LOCATION_GRAVE,0,nil,e,tp):Filter(Card.IsCanBeEffectTarget,nil,e)
	local b2=Duel.GetMatchingGroup(cm.t,tp,LOCATION_GRAVE,0,1,nil):Filter(Card.IsCanBeEffectTarget,nil,e)
	if chk==0 then return #b1>0 or #b2>0 end
	local sg=Group.CreateGroup()
	sg:Merge(b1)
	sg:Merge(b2)
	Duel.Hint(3,tp,HINTMSG_TARGET)
	local g=sg:Select(tp,1,1,nil)
	Duel.SetTargetCard(g)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	local b1=cm.r(tc,e,tp)
	local b2=cm.t(tc)	
	local op=aux.SelectFromOptions(tp,{b1,aux.Stringid(m,2),0},{b2,aux.Stringid(m,3),1})
	if op==0 then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	elseif op==1 then
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)	
	end
end