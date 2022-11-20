--真的牛皮
--bug card
function c10173078.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,nil,2)
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c10173078.adval)
	c:RegisterEffect(e1)  
	--damage
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10173078,0))
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(TIMING_SPSUMMON,TIMING_BATTLE_START)
	e2:SetCountLimit(1)
	e2:SetCondition(c10173078.damcon)
	e2:SetTarget(c10173078.damtg)
	e2:SetOperation(c10173078.damop)
	c:RegisterEffect(e2)
end
function c10173078.damcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	if Duel.GetTurnPlayer()==tp then
		return ph==PHASE_MAIN1 or ph==PHASE_MAIN2
	else
		return (ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE)
	end
end
function c10173078.adval(e,c)
	return Duel.GetFieldGroupCount(c:GetControler(),0,LOCATION_ONFIELD)*1000
end
function c10173078.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsPosition,tp,0,LOCATION_MZONE,1,nil,POS_FACEUP_ATTACK) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,0,0,LOCATION_MZONE)
end
function c10173078.damop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local f=function(rc)
		return rc:IsPosition(POS_FACEUP_ATTACK) and not rc:IsType(TYPE_TOKEN)
	end
	local g=Duel.GetMatchingGroup(f,tp,0,LOCATION_MZONE,nil)
	if not c:IsRelateToEffect(e) or #g<=0 then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_BATTLED)
	e1:SetOperation(c10173078.rmop)
	Duel.RegisterEffect(e1,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUPATTACK)
	local tc=g:Select(1-tp,1,1,nil):GetFirst()
	local atk=tc:GetBaseAttack()
	if atk<0 then atk=0 end
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_SET_BATTLE_ATTACK)
	e2:SetReset(RESET_PHASE+PHASE_DAMAGE)
	e2:SetValue(atk)
	tc:RegisterEffect(e2,true)
	e1:SetLabelObject(tc)
	Duel.CalculateDamage(c,tc)
end
function c10173078.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=e:GetLabelObject()
	local tbl={}
	tbl[tp]=c
	tbl[1-tp]=tc
	for i=0,1 do
		local dam=Duel.GetBattleDamage(i)
		if dam>0 then
		   Duel.Remove(tbl[i],POS_FACEDOWN,REASON_RULE)
		end
	end
	e:Reset()
end
