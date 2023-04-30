--维尔薇的魔术表演
function c32131331.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c) 
	e1:SetDescription(aux.Stringid(32131331,1))
	e1:SetCategory(CATEGORY_POSITION+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_BATTLE_START+TIMING_BATTLE_END)
	e1:SetCondition(c32131331.accon1)
	e1:SetTarget(c32131331.actg1)
	e1:SetOperation(c32131331.acop1)
	c:RegisterEffect(e1) 
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(32131331,2))
	e1:SetCategory(CATEGORY_CONTROL)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetCondition(c32131331.accon2)
	e1:SetTarget(c32131331.actg2)
	e1:SetOperation(c32131331.acop2)
	c:RegisterEffect(e1)
end 
c32131331.SetCard_HR_flame13=true  
function c32131331.accon1(e,tp,eg,ep,ev,re,r,rp)
	return (Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE)
end
function c32131331.xfilter(c)
	return c:GetSequence()<5 and (c:IsPosition(POS_FACEDOWN_DEFENSE) or c:IsCanTurnSet())
end
function c32131331.spfilter(c,e,tp)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and Duel.IsPlayerCanSpecialSummonMonster(tp,c:GetCode(),nil,TYPE_MONSTER+TYPE_NORMAL,0,0,0,0,0,POS_FACEDOWN_DEFENSE)
		and c:IsCanBeSpecialSummoned(e,0,tp,true,true,POS_FACEDOWN_DEFENSE)
end
function c32131331.actg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c32131331.xfilter,tp,LOCATION_MZONE,0,1,nil)
		and not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>1
		and Duel.IsExistingMatchingCard(c32131331.spfilter,tp,LOCATION_DECK,0,2,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,0)
end
function c32131331.acop1(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<2 then return end
	local g=Duel.GetMatchingGroup(c32131331.spfilter,tp,LOCATION_DECK,0,nil,e,tp)
	if g:GetCount()<2 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g2=Duel.SelectMatchingCard(tp,c32131331.xfilter,tp,LOCATION_MZONE,0,1,1,nil)
	local tc=g2:GetFirst()
	if not tc or tc:IsImmuneToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=g:Select(tp,2,2,nil)
	if tc:IsFaceup() then
		Duel.ChangePosition(tc,POS_FACEDOWN_DEFENSE)
		tc:ClearEffectRelation()
	end
	local tg=sg:GetFirst()
	local fid=e:GetHandler():GetFieldID()
	while tg do
		local e1=Effect.CreateEffect(tg)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(TYPE_NORMAL+TYPE_MONSTER)
		e1:SetReset(RESET_EVENT+0x47c0000)
		tg:RegisterEffect(e1,true)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_REMOVE_RACE)
		e2:SetValue(RACE_ALL)
		tg:RegisterEffect(e2,true)
		local e3=e1:Clone()
		e3:SetCode(EFFECT_REMOVE_ATTRIBUTE)
		e3:SetValue(0xff)
		tg:RegisterEffect(e3,true)
		local e4=e1:Clone()
		e4:SetCode(EFFECT_SET_BASE_ATTACK)
		e4:SetValue(0)
		tg:RegisterEffect(e4,true)
		local e5=e1:Clone()
		e5:SetCode(EFFECT_SET_BASE_DEFENSE)
		e5:SetValue(0)
		tg:RegisterEffect(e5,true)
		tg:RegisterFlagEffect(32131331,RESET_EVENT+0x47c0000+RESET_PHASE+PHASE_BATTLE,0,1,fid)
		tg:SetStatus(STATUS_NO_LEVEL,true)
		tg=sg:GetNext()
	end
	Duel.SpecialSummon(sg,0,tp,tp,true,false,POS_FACEDOWN_DEFENSE)
	Duel.ConfirmCards(1-tp,sg)
	sg:AddCard(tc)
	Duel.ShuffleSetCard(sg)
	sg:RemoveCard(tc)
	sg:KeepAlive()
	local de=Effect.CreateEffect(e:GetHandler())
	de:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	de:SetCode(EVENT_PHASE+PHASE_BATTLE)
	de:SetReset(RESET_PHASE+PHASE_BATTLE)
	de:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	de:SetCountLimit(1)
	de:SetLabel(fid)
	de:SetLabelObject(sg)
	de:SetOperation(c32131331.desop)
	Duel.RegisterEffect(de,tp)
end
function c32131331.desfilter(c,fid)
	return c:GetFlagEffectLabel(32131331)==fid
end
function c32131331.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local fid=e:GetLabel()
	local tg=g:Filter(c32131331.desfilter,nil,fid)
	g:DeleteGroup()
	Duel.SendtoDeck(tg,nil,2,REASON_EFFECT)
	local tg2=tg:Filter(c32131331.desfilter,nil,fid)
	Duel.SendtoDeck(tg2,nil,2,REASON_EFFECT)
end
function c32131331.accon2(e,tp,eg,ep,ev,re,r,rp)
	return tp~=Duel.GetTurnPlayer() and Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)>0
end
function c32131331.cfilter(c)
	return c:IsFaceup() and c:IsControlerCanBeChanged()
end
function c32131331.actg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local atr=Duel.GetAttacker()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c32131331.cfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c32131331.cfilter,tp,0,LOCATION_MZONE,1,atr) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g=Duel.SelectTarget(tp,c32131331.cfilter,tp,0,LOCATION_MZONE,1,1,atr)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,1,0,0)
end
function c32131331.acop2(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local tc=Duel.GetFirstTarget()
	local a=Duel.GetAttacker()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and Duel.GetControl(tc,tp,PHASE_BATTLE,1)~=0 then
		if a:IsAttackable() and not a:IsImmuneToEffect(e) then
			Duel.CalculateDamage(a,tc)
		end
	end
end
