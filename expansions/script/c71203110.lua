local s,id,o=GetID()
function s.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,s.matfilter,1,1)
	c:EnableReviveLimit()
	c:SetSPSummonOnce(id)
	--unique
	c:SetUniqueOnField(1,0,id,LOCATION_MZONE)
	--draw
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.drtg)
	e1:SetOperation(s.drop)
	c:RegisterEffect(e1)
	--damage
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_DAMAGE+CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BATTLE_START)
	e2:SetTarget(s.tgtg)
	e2:SetOperation(s.tgop)
	c:RegisterEffect(e2)
end
function s.matfilter(c)
	return c:IsLinkSetCard(0x899) and not c:IsLinkCode(id)
end
function s.trapfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x899) and c:IsType(TYPE_CONTINUOUS) and c:IsType(TYPE_TRAP)
end
function s.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local ct=Duel.GetMatchingGroupCount(s.trapfilter,tp,LOCATION_SZONE,0,nil)
		return ct>0 and Duel.IsPlayerCanDraw(tp,ct)
	end
	local ct=Duel.GetMatchingGroupCount(s.trapfilter,tp,LOCATION_SZONE,0,nil)
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(ct)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,ct)
end
function s.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function s.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local d=Duel.GetAttackTarget()
	if chk==0 then return Duel.GetAttacker()==e:GetHandler() and d and d:IsDefensePos() end
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,1800)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,d,1,0,0)
end
function s.tgop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.Damage(1-tp,1800,REASON_EFFECT)~=0 then
		local d=Duel.GetAttackTarget()
		if d and d:IsRelateToBattle() and d:IsDefensePos() then
			Duel.SendtoGrave(d,REASON_EFFECT)
		end
	end
end
