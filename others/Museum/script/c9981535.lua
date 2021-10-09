--盖亚记忆体-永恒-
function c9981535.initial_effect(c)
	 c:SetUniqueOnField(1,0,9981535)
	 --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(c9981535.sumsuc)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9981535,0))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BATTLE_DESTROYED)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(c9981535.bdcon)
	e2:SetTarget(c9981535.bdtg)
	e2:SetOperation(c9981535.bdop)
	c:RegisterEffect(e2)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9981535,0))
	e2:SetCategory(CATEGORY_DRAW+CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c9981535.con)
	e2:SetTarget(c9981535.tg)
	e2:SetOperation(c9981535.op)
	c:RegisterEffect(e2)
	--atk down
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x3bc2))
	e2:SetValue(300)
	c:RegisterEffect(e2)
end
function c9981535.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9981535,0))
end 
function c9981535.cfilter(c,tp)
	local rc=c:GetReasonCard()
	return c:IsReason(REASON_BATTLE) and c:GetPreviousControler()==tp and c:IsSetCard(0x3bc2)
		and rc and rc:IsControler(1-tp) and rc:IsRelateToBattle()
end
function c9981535.bdcon(e,tp,eg,ep,ev,re,r,rp)
	local dc=eg:Filter(c9981535.cfilter,nil,tp):GetFirst()
	if dc then
		e:SetLabelObject(dc:GetReasonCard())
		return true
	else return false end
end
function c9981535.bdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetLabelObject(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,0)
end
function c9981535.bdop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc and tc:IsRelateToBattle() then
		if Duel.Destroy(tc,REASON_EFFECT)>0 then
			Duel.Damage(1-tp,tc:GetBaseAttack()/2,REASON_EFFECT)
		end
	end
end
function c9981535.gfilter(c,tp)
	return c:IsSetCard(0x3bc2) and c:IsControler(tp)
end
function c9981535.con(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c9981535.gfilter,1,nil,tp)
end
function c9981535.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c9981535.op(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9981535,0))
end
