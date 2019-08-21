--时穿剑·太初剑
local m=14000001
local cm=_G["c"..m]
if not Chrono then
	Chrono=Chrono or {}
	chrb=Chrono
	function chrb.dire(c,direbool,t)
		--direct attack
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DIRECT_ATTACK)
		if not direbool then
			e1:SetCondition(chrb.dircon)
		end
		c:RegisterEffect(e1)
		if not t then
			--battle damage to effect damage
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_BATTLE_DAMAGE_TO_EFFECT)
			c:RegisterEffect(e2)
		else
			--damage change
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
			e2:SetCode(EVENT_PRE_BATTLE_DAMAGE)
			e2:SetValue(t)
			e2:SetLabel(0)
			--e2:SetCondition(chrb.damcon)
			e2:SetOperation(chrb.damop)
			c:RegisterEffect(e2)
			local e2_1=Effect.CreateEffect(c)
			e2_1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
			e2_1:SetCode(EVENT_BATTLED)
			e2_1:SetLabel(t)
			e2_1:SetLabelObject(e2)
			e2_1:SetOperation(chrb.burnop)
			c:RegisterEffect(e2_1)
		end
		--actlimit
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD)
		e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e3:SetCode(EFFECT_CANNOT_ACTIVATE)
		e3:SetRange(LOCATION_MZONE)
		e3:SetTargetRange(0,1)
		e3:SetValue(aux.TRUE)
		e3:SetCondition(chrb.actcon)
		c:RegisterEffect(e3)
	end
	function chrb.ChronoDamageEffect(c,cate,prop,range,cost,tg,op,conbool,limitbool,typebool)
		local code=c:GetOriginalCodeRule()
		local e4=Effect.CreateEffect(c)
		e4:SetDescription(aux.Stringid(code,0))
		if cate then
			e4:SetCategory(cate)
		end
		if typebool and typebool==true then
			e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
		else
			e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
		end
		prop=prop or 0
		prop=prop+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL
		e4:SetProperty(prop)
		e4:SetCode(EVENT_DAMAGE)
		if not limitbool or limitbool==false then
			e4:SetCountLimit(1)
		end
		if range then
			e4:SetRange(range)
		else
			e4:SetRange(LOCATION_MZONE)
		end
		if cost then
			e4:SetCost(cost)
		end
		if conbool and conbool==true then
			e4:SetCondition(chrb.con)
		else
			e4:SetCondition(chrb.con1)
		end
		if tg then
			e4:SetTarget(tg)
		end
		e4:SetOperation(op)
		c:RegisterEffect(e4)
		local ccode=_G["c"..code]
		ccode.ChronoDamageEffect=e4
	end
	function chrb.CHRB(c)
		local m=_G["c"..c:GetCode()]
		return m and m.named_with_Chronoblade
	end
	function chrb.con(e,tp,eg,ep,ev,re,r,rp)
		return ep~=tp and bit.band(r,REASON_EFFECT)~=0 and chrb.CHRB(re:GetHandler()) and not re:GetHandler():IsCode(m)
	end
	function chrb.con1(e,tp,eg,ep,ev,re,r,rp)
		return ep~=tp and bit.band(r,REASON_EFFECT)~=0 and chrb.CHRB(re:GetHandler())
	end
	function chrb.dircon(e)
		return e:GetHandler():GetColumnGroupCount()==0
	end
	function chrb.actcon(e)
		return Duel.GetAttacker()==e:GetHandler() or Duel.GetAttackTarget()==e:GetHandler()
	end
	function chrb.move(e,tp,eg,ep,ev,re,r,rp,tgbool)
		if tgbool then
			local tc=Duel.GetFirstTarget()
			if not tc or not tc:IsRelateToEffect(e) or tc:IsControler(1-tp) or Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
			local s=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,0)
			local nseq=math.log(s,2)
			if Duel.MoveSequence(tc,nseq) then return true end
		else
			local c=e:GetHandler()
			if not c:IsRelateToEffect(e) or Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
			local s=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,0)
			local nseq=math.log(s,2)
			if Duel.MoveSequence(c,nseq) then return true end
		end
	end
	function chrb.damcon(e,tp,eg,ep,ev,re,r,rp)
		local a,b,c=Duel.GetAttacker(),Duel.GetAttackTarget(),e:GetHandler()
		return ((a and a==c) or (b and b==c)) and ep~=tp
	end
	function chrb.damop(e,tp,eg,ep,ev,re,r,rp)
		e:SetLabel(ev/e:GetValue())
		Duel.ChangeBattleDamage(ep,0)
	end
	function chrb.burnop(e,tp,eg,ep,ev,re,r,rp)
		value,count=e:GetLabelObject():GetLabel(),e:GetLabel()
		while value>0 and count>0 do
			Duel.Damage(1-tp,value,REASON_EFFECT)
			count=count-1
		end
	end
end
--selfeffects
if cm then
	cm.named_with_Chronoblade=1
	function cm.initial_effect(c)
		--chrbeffects
		chrb.dire(c)
		--spsummon
		local e4=Effect.CreateEffect(c)
		e4:SetDescription(aux.Stringid(m,1))
		e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
		e4:SetType(EFFECT_TYPE_QUICK_O)
		e4:SetCode(EVENT_FREE_CHAIN)
		e4:SetHintTiming(0,TIMING_BATTLE_START+TIMING_BATTLE_END)
		e4:SetRange(LOCATION_MZONE)
		e4:SetCountLimit(1)
		e4:SetCondition(cm.spcon)
		e4:SetTarget(cm.sptg)
		e4:SetOperation(cm.spop)
		c:RegisterEffect(e4)
	end
	function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
		local ph=Duel.GetCurrentPhase()
		return ph==PHASE_MAIN1 or (ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE) or ph==PHASE_MAIN2
	end
	function cm.spfilter(c,e,tp)
		return chrb.CHRB(c) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	end
	function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_CONTROL)>0 and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
	end
	function cm.spop(e,tp,eg,ep,ev,re,r,rp)
		chrb.move(e,tp,eg,ep,ev,re,r,rp)
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end