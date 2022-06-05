--魔皇龙 夜牙月破
function c25000026.initial_effect(c)
	--fusion summon
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,c25000026.ffilter,3,false)
	aux.AddContactFusionProcedure(c,Card.IsReleasable,LOCATION_MZONE,0,Duel.Release,REASON_COST+REASON_MATERIAL)	
	--spsummon condition
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(c25000026.splimit)
	c:RegisterEffect(e0)
	--pierce
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_PIERCE)
	c:RegisterEffect(e1)
	--disable 
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(25000026,0))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_SSET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,25000026)
	e2:SetTarget(c25000026.dstg)
	e2:SetOperation(c25000026.dsop)
	c:RegisterEffect(e2)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_CHANGE_BATTLE_DAMAGE)
	e5:SetCondition(function(e)return Duel.GetAttacker()==e:GetHandler()end)
	e5:SetValue(aux.ChangeBattleDamage(1,DOUBLE_DAMAGE))
	c:RegisterEffect(e5)
end
function c25000026.ffilter(c,fc,sub,mg,sg)
	return ( not sg or sg:GetClassCount(Card.GetLevel)==1) and c:IsRace(RACE_FIEND)
end
function c25000026.splimit(e,se,sp,st)
	return e:GetHandler():GetLocation()~=LOCATION_EXTRA
end
function c25000026.dstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_ONFIELD,1,nil) end
end
function c25000026.dsop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(nil,tp,0,LOCATION_ONFIELD,nil)
	if g:GetCount()>0 then 
	local tc=g:Select(tp,1,1,nil):GetFirst()
	Duel.HintSelection(Group.FromCards(tc))
	--cannot trigger
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_TRIGGER)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD)
	tc:RegisterEffect(e2)
	if tc:IsType(TYPE_MONSTER) and tc:IsFaceup() then 
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_ATTACK)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
	local x=Duel.GetLP(1-tp)/2
	Duel.PayLPCost(1-tp,x)
	Duel.Recover(tp,x,REASON_EFFECT) 
	end
	end
end






