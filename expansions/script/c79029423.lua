--异格干员-炎狱炎熔
function c79029423.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,11,3)
	c:EnableReviveLimit()
	--add code
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_ADD_CODE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetValue(79029166)
	c:RegisterEffect(e2)  
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(79029423,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SPSUM_PARAM)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetTargetRange(POS_FACEUP,1)
	e1:SetValue(SUMMON_VALUE_SELF)
	e1:SetCondition(c79029423.spcon)
	e1:SetOperation(c79029423.spop)
	c:RegisterEffect(e1)	
	Duel.AddCustomActivityCounter(79029423,ACTIVITY_SPSUMMON,c79029423.counterfilter)
	--xyz
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_EXTRA_ATTACK)
	e4:SetValue(1)
	e4:SetCondition(c79029423.xyzcon)
	c:RegisterEffect(e4)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_PIERCE)
	e4:SetValue(DOUBLE_DAMAGE)
	e4:SetCondition(c79029423.xyzcon)
	c:RegisterEffect(e4)
	--Release
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetCode(EFFECT_UNRELEASABLE_SUM)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCondition(c79029423.rlcon)
	e5:SetValue(1)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EFFECT_UNRELEASABLE_NONSUM)
	c:RegisterEffect(e6)
	local e7=e5:Clone()
	e7:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	e7:SetValue(c79029423.fuslimit)
	c:RegisterEffect(e7)
	local e8=e5:Clone()
	e8:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	c:RegisterEffect(e8)
	local e9=e5:Clone()
	e9:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	c:RegisterEffect(e9)
	local e10=e5:Clone()
	e10:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	c:RegisterEffect(e10)  
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e11:SetCategory(CATEGORY_DAMAGE)
	e11:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e11:SetRange(LOCATION_MZONE)
	e11:SetCountLimit(1)
	e11:SetCondition(c79029423.rlcon)
	e11:SetTarget(c79029423.damtg)
	e11:SetOperation(c79029423.damop)
	c:RegisterEffect(e11)  
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_SINGLE)
	e11:SetCode(EFFECT_CANNOT_ATTACK)
	e11:SetCondition(c79029423.rlcon)
	c:RegisterEffect(e11)
	--Overlay
	local e12=Effect.CreateEffect(c)
	e12:SetType(EFFECT_TYPE_IGNITION)
	e12:SetRange(LOCATION_MZONE)
	e12:SetProperty(EFFECT_FLAG_BOTH_SIDE)
	e12:SetCountLimit(1,79029423)
	e12:SetCondition(c79029423.ovcon)
	e12:SetCost(c79029423.ovcost)
	e12:SetTarget(c79029423.ovtg)
	e12:SetOperation(c79029423.ovop)
	c:RegisterEffect(e12)
	--chain attack
	local e13=Effect.CreateEffect(c)
	e13:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e13:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e13:SetCode(EVENT_BATTLE_DESTROYING)
	e13:SetCondition(c79029423.atcon)
	e13:SetCost(c79029423.atcost)
	e13:SetTarget(c79029423.attg)
	e13:SetOperation(c79029423.atop)
	c:RegisterEffect(e13)
	--atk
	local e14=Effect.CreateEffect(c)
	e14:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e14:SetCode(EVENT_ATTACK_ANNOUNCE)
	e14:SetCondition(c79029423.escon)
	e14:SetOperation(c79029423.esop)
	c:RegisterEffect(e14)
end
function c79029423.counterfilter(c)
	return c:IsSetCard(0xa900)
end
function c79029423.filter1(c,tp,rg)
	return rg:IsExists(c79029423.filter2,1,c,tp,c)
end
function c79029423.filter2(c,tp,mc)
	local mg=Group.FromCards(c,mc)
	return Duel.GetMZoneCount(1-tp,mg,tp)>0
end
function c79029423.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local rg=Duel.GetMatchingGroup(Card.IsReleasable,tp,0,LOCATION_MZONE,nil)
	return rg:IsExists(c79029423.filter1,1,nil,tp,rg) and Duel.GetActivityCount(tp,ACTIVITY_NORMALSUMMON)==0
end
function c79029423.esfil(c)
	return c:IsCode(79029443,79029247)
end
function c79029423.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local rg=Duel.GetMatchingGroup(Card.IsReleasable,tp,0,LOCATION_MZONE,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=rg:FilterSelect(tp,c79029423.filter1,1,1,nil,tp,rg)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g2=rg:FilterSelect(tp,c79029423.filter2,1,1,g:GetFirst(),tp,g:GetFirst())
	g:Merge(g2)
	Duel.Release(g,REASON_COST)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_MSET)
	Duel.RegisterEffect(e2,tp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c79029423.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	if Duel.IsExistingMatchingCard(c79029423.esfil,tp,LOCATION_MZONE,0,1,nil) then
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029423,10)) 
	Duel.Hint(HINT_MESSAGE,0,aux.Stringid(79029423,13))   
	else
	Debug.Message("背后就交给你了，我去会会那些对手。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029423,5))
	end
end
function c79029423.splimit(e,c,tp,sumtp,sumpos)
	return not c:IsSetCard(0xa900)
end
function c79029423.xyzcon(e,c)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function c79029423.rlcon(e,c)
	return e:GetHandler():IsSummonType(SUMMON_VALUE_SELF)
end
function c79029423.fuslimit(e,c,sumtype)
	return sumtype==SUMMON_TYPE_FUSION
end
function c79029423.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetTurnPlayer()==tp end
	local x=e:GetHandler():GetOverlayCount()
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1000+x*500)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,0,0,tp,1000+x*500)
end
function c79029423.damop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsExistingMatchingCard(c79029423.esfil,tp,0,LOCATION_MZONE,1,nil) then
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029423,11)) 
	Duel.Hint(HINT_MESSAGE,0,aux.Stringid(79029423,14))   
	else
	Debug.Message("被邪恶浸染的有罪灵魂，不配得到宽恕。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029423,6))
	end
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end
function c79029423.ovcon(e,c)
	local tp=e:GetHandler():GetOwner()
	return Duel.GetTurnPlayer()==tp
end
function c79029423.ovcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local x=Duel.GetMatchingGroupCount(Card.IsCanOverlay,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c)
	if chk==0 then return Duel.CheckLPCost(tp,1000) end
	local lp=Duel.GetLP(tp)
	local t={}
	local f=math.floor((lp)/1000)
	local l=1
	while l<=f and l<=x-1 do
		t[l]=l*1000
		l=l+1
	end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(79029423,1))
	local announce=Duel.AnnounceNumber(tp,table.unpack(t))
	Duel.PayLPCost(tp,announce)
	e:SetLabel(announce)
end
function c79029423.ovtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsCanOverlay,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c) end
end
function c79029423.ovop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local d=e:GetLabel()
	local x=math.floor(d/1000)
	local g=Duel.GetMatchingGroup(Card.IsCanOverlay,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,c)
	if g:GetCount()<=0 then return end
	local og=g:Select(tp,x,x,nil)
	Debug.Message("太弱了，躲藏是没用的。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029423,7))
	Duel.Overlay(c,og)
end
function c79029423.atcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return c==Duel.GetAttacker() and c:IsRelateToBattle() and c:IsStatus(STATUS_OPPO_BATTLE) and bc:IsLocation(LOCATION_GRAVE) and bc:IsType(TYPE_MONSTER)
end
function c79029423.atcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c79029423.attg(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.GetAttackTarget():IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE,tp)
	local b2=Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 and Duel.GetAttackTarget():IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE,1-tp)
	if chk==0 then return b1 or b2 end
	local op=0
	if b1 and b2 then
	op=Duel.SelectOption(tp,aux.Stringid(79029423,3),aux.Stringid(79029423,4))
	elseif b1 then
	op=Duel.SelectOption(tp,aux.Stringid(79029423,3))
	else
	op=Duel.SelectOption(tp,aux.Stringid(79029423,4))+1
	end
	e:SetLabel(op)
	Duel.GetAttackTarget():CreateEffectRelation(e)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,Duel.GetAttackTarget(),1,0,0)
end
function c79029423.atop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=Duel.GetAttackTarget()
	if not bc:IsRelateToEffect(e) then return end
	local op=e:GetLabel()
	local p=0
	if op==0 then
	Debug.Message("我并不擅长这种事......只要快点结束就可以了吧。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029423,8))
	p=tp
	else
	Debug.Message("哼......在痛苦和恐惧中溃败吧。所有的罪恶必将被讨伐。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029423,9))
	p=1-tp
	end 
	if Duel.SpecialSummonStep(bc,0,tp,p,false,false,POS_FACEUP_DEFENSE) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_DEFENSE)
		e1:SetValue(0)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		bc:RegisterEffect(e1)
		Duel.SpecialSummonComplete()
	end
end
function c79029423.escon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c79029423.esfil,tp,LOCATION_MZONE,0,1,nil)
end
function c79029423.esop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029423,12)) 
	Duel.Hint(HINT_MESSAGE,0,aux.Stringid(79029423,15))   
end













