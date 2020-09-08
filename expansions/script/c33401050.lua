--天使-灼烂歼鬼
local m=33401050
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:SetUniqueOnField(1,0,m)
	   --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMING_END_PHASE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,m)
	e2:SetTarget(cm.sptg)
	e2:SetOperation(cm.spop)
	c:RegisterEffect(e2)
--Remove 
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetCode(EVENT_BATTLED)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(cm.rmtg)
	e3:SetOperation(cm.rmop)
	c:RegisterEffect(e3)
 --change code
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,2))
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCountLimit(1,m+20000)
	e4:SetCondition(cm.changecon)
	e4:SetTarget(cm.changetg)
	e4:SetOperation(cm.changeop) 
	c:RegisterEffect(e4)
end
function cm.spfilter(c,e,tp)
	return c:IsSetCard(0x9341) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and cm.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(cm.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,cm.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,nil,tp,500)
	
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
   local c=e:GetHandler()
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget() 
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 or not tc:IsRelateToEffect(e) then return end
	  if  Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)~=0 then 
		 Duel.Damage(tp,500,REASON_EFFECT)
		  --self dmck
		local e5=Effect.CreateEffect(c)
		e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e5:SetCode(EVENT_ATTACK_ANNOUNCE)
		e5:SetLabelObject(tc)
		e5:SetOperation(cm.ckop)	
		e5:SetReset(RESET_EVENT+RESETS_STANDARD)  
		tc:RegisterEffect(e5,true)
		local e6=Effect.CreateEffect(c)
		e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e6:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
		e6:SetRange(LOCATION_MZONE)
		e6:SetLabelObject(tc)
		e6:SetOperation(cm.ckop)  
		e6:SetReset(RESET_EVENT+RESETS_STANDARD)	 
		tc:RegisterEffect(e6,true)
		tc:RegisterFlagEffect(m+1,RESET_EVENT+RESETS_STANDARD,0,1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_PHASE+PHASE_END)
		e2:SetCountLimit(1)
		e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e2:SetLabelObject(tc)
		e2:SetCondition(cm.descon)
		e2:SetOperation(cm.desop)
		Duel.RegisterEffect(e2,tp)
	  end
end
function cm.ckop(e,tp,eg,ep,ev,re,r,rp)
local tc=e:GetLabelObject()
tc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1) 
end

function cm.descon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffect(m+1)==0 then
		  e:Reset()
		return false
	end
	if  tc:GetFlagEffect(m)~=0  then
		return false	 
	else		 
		return true
	end
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.Destroy(tc,REASON_EFFECT)
end

function cm.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
 if d~=nil and d:IsControler(tp) then t=a a=d d=t end
	if chk==0 then return d~=nil and d:IsAbleToRemove() and a:IsControler(tp) and a:IsSetCard(0x9341)
	   and a:IsType(TYPE_FUSION) and d:GetAttack()<a:GetAttack() end
	e:SetLabelObject(d)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,d,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,nil,1-tp,500)
end
function cm.rmop(e,tp,eg,ep,ev,re,r,rp)
	 local d=e:GetLabelObject()
	if e:GetHandler():IsRelateToEffect(e) and d:IsRelateToBattle() then
		Duel.Remove(d,POS_FACEUP,REASON_EFFECT)
	end
	Duel.Damage(1-tp,500,REASON_EFFECT)
end

function cm.filter4(c)
	return c:IsFaceup() and c:IsSetCard(0x9341) and c:IsType(TYPE_FUSION)
end
function cm.changecon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(cm.filter4,tp,LOCATION_MZONE,0,1,nil)
end
function cm.changetg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return 33401051 and 33401050==c:GetOriginalCode() end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function cm.changeop(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() or c:IsImmuneToEffect(e) then return end
	c:SetEntityCode(33401051,true)
	c:ReplaceEffect(33401051,0,0)
end
