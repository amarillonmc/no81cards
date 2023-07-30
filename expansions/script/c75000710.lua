--曲射的疾風隼騎士 日乃香
local m=75000710
local cm=_G["c"..m]
function cm.initial_effect(c)
	--synchro summon
	c:EnableReviveLimit()
	local e01=Effect.CreateEffect(c)
	e01:SetDescription(1164)
	e01:SetType(EFFECT_TYPE_FIELD)
	e01:SetCode(EFFECT_SPSUMMON_PROC)
	e01:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e01:SetRange(LOCATION_EXTRA)
	e01:SetCondition(cm.syncon)
	e01:SetOperation(cm.synop)
	e01:SetValue(SUMMON_TYPE_SYNCHRO)
	c:RegisterEffect(e01)
	--Effect 1
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DIRECT_ATTACK)
	c:RegisterEffect(e1)
	--Effect 2  
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_BATTLE_DAMAGE)
	e3:SetCountLimit(1,m)
	e3:SetCondition(cm.thcon)
	e3:SetTarget(cm.thtg)
	e3:SetOperation(cm.thop)
	c:RegisterEffect(e3)
	--Effect 3  
	local e51=Effect.CreateEffect(c)
	e51:SetDescription(aux.Stringid(m,1))
	e51:SetCategory(CATEGORY_POSITION)
	e51:SetType(EFFECT_TYPE_QUICK_O)
	e51:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e51:SetCode(EVENT_FREE_CHAIN)
	e51:SetRange(LOCATION_MZONE)
	e51:SetCountLimit(1)
	e51:SetTarget(cm.postg)
	e51:SetOperation(cm.posop)
	c:RegisterEffect(e51)  
end
--
function cm.SynchroMaterial(tc)
	if tc:GetSynchroType()&TYPE_MONSTER==0 or tc:GetType()&TYPE_LINK~=0 then return false end
	if tc:IsStatus(STATUS_FORBIDDEN) then return false end
	if tc:IsHasEffect(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL) then return false end
	return true 
end
function cm.GetSynMaterials(tp,syncard)
	local mg=Duel.GetMatchingGroup(cm.f,tp,LOCATION_MZONE,LOCATION_MZONE,nil,tp,syncard)
	if mg:IsExists(Card.GetHandSynchro,1,nil) then
		local mg2=Duel.GetMatchingGroup(Card.IsCanBeSynchroMaterial,tp,LOCATION_HAND,0,nil,syncard)
		if mg2:GetCount()>0 then mg:Merge(mg2) end
	end
	return mg
end
--synchro summon
function cm.f(c,tp,tc)
	local b1=c:IsFaceup() and cm.SynchroMaterial(c)
	local b2=c:IsControler(1-tp) and (c:IsSetCard(0x750) or c:IsHasEffect(EFFECT_SYNCHRO_MATERIAL))
	return c:IsLevelAbove(1) and b1 and (c:IsControler(tp) or b2)
end
function cm.f1(c)
	return c:IsSynchroType(TYPE_TUNER) 
end
function cm.f2(c)
	return not c:IsSynchroType(TYPE_TUNER)
end
function cm.f3(c,tp)
	return c:IsSetCard(0xe75) and c:IsControler(1-tp) and not c:IsHasEffect(EFFECT_SYNCHRO_MATERIAL)
end
function cm.fs(g,tp,tc) 
	return g:FilterCount(cm.f3,nil,tp)<=1
		and g:FilterCount(cm.f1,nil)==1
		and g:GetSum(Card.GetSynchroLevel,tc)==tc:GetLevel()
		and g:FilterCount(cm.f2,nil)==#g-1   
		and Duel.GetLocationCountFromEx(tp,tp,g,tc)>0
end
function cm.syncon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=cm.GetSynMaterials(tp,c)
	return g:CheckSubGroup(cm.fs,2,#g,tp,c)
end
function cm.synop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=cm.GetSynMaterials(tp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
	local tg=g:SelectSubGroup(tp,cm.fs,false,2,#g,tp,c)
	c:SetMaterial(tg)
	Duel.SendtoGrave(tg,REASON_MATERIAL+REASON_SYNCHRO)
end
--Effect 1
function cm.spfilter(c,e,tp)
	local b1=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	local b2=Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,1-tp)
	return c:IsSetCard(0x750) and (b1 or b2)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and cm.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(cm.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp)  end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,cm.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	local b1=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and tc:IsCanBeSpecialSummoned(e,0,tp,false,false)
	local b2=Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 and tc:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,1-tp)
	local res=false
	if b1 and b2 then
		op=Duel.SelectOption(tp,aux.Stringid(m,1),aux.Stringid(id,2))
	elseif b1 then
		op=Duel.SelectOption(tp,aux.Stringid(m,1))
	elseif b2 then
		op=Duel.SelectOption(tp,aux.Stringid(m,2))+1
	else return end
	if op==0 then
		res=Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetValue(RESET_TURN_SET)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e2)
			tc=sg:GetNext()
		Duel.SpecialSummonComplete()
	else
		res=Duel.SpecialSummonStep(tc,0,tp,1-tp,false,false,POS_FACEUP)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetValue(RESET_TURN_SET)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e2)
			tc=sg:GetNext()
		Duel.SpecialSummonComplete()
	end
end
--Effect 2
function cm.sp(c,e,tp)
	local b1=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	local b2=Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,1-tp)
	return c:IsSetCard(0x750) and (b1 or b2)
end
function cm.thcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(cm.sp,tp,LOCATION_DECK,0,nil,e,tp)
	if #g==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local tc=g:Select(tp,1,1,nil):GetFirst()
	if not tc then return end
	local b1=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and tc:IsCanBeSpecialSummoned(e,0,tp,false,false)
	local b2=Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 and tc:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,1-tp)
	local res=false
	if b1 and b2 then
		op=Duel.SelectOption(tp,aux.Stringid(m,2),aux.Stringid(m,3))
	elseif b1 then
		op=Duel.SelectOption(tp,aux.Stringid(m,2))
	elseif b2 then
		op=Duel.SelectOption(tp,aux.Stringid(m,3))+1
	else return end
	if op==0 then
		res=Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetValue(RESET_TURN_SET)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e2)
		Duel.SpecialSummonComplete()
	else
		res=Duel.SpecialSummonStep(tc,0,tp,1-tp,false,false,POS_FACEUP)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetValue(RESET_TURN_SET)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e2)
		Duel.SpecialSummonComplete()
	end  
end
--Effect 3
function cm.posfilter(c)
	return c:IsAttackPos() and c:IsCanChangePosition()
end
function cm.postg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and cm.posfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.posfilter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	local g=Duel.SelectTarget(tp,cm.posfilter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
end
function cm.posop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsAttackPos() and tc:IsRelateToEffect(e) then
		Duel.ChangePosition(tc,POS_FACEUP_DEFENSE)
	end
end

