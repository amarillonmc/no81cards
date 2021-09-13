--方舟骑士·猎狼人 红
function c82567800.initial_effect(c)
	--summon with no tribute
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(82567800,0))
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SUMMON_PROC)
	e1:SetCondition(c82567800.ntcon)
	c:RegisterEffect(e1)
	--direct attack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_DIRECT_ATTACK)
	c:RegisterEffect(e2)
	--draw(battle)
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_BATTLE_DAMAGE)
	e3:SetCountLimit(1)
	e3:SetCondition(c82567800.drcon)
	e3:SetTarget(c82567800.drtg)
	e3:SetOperation(c82567800.drop)
	c:RegisterEffect(e3)
	--to hand
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(82567800,1))
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCountLimit(1)
	e4:SetCondition(c82567800.thcon)
	e4:SetTarget(c82567800.thtg)
	e4:SetOperation(c82567800.thop)
	c:RegisterEffect(e4)
end
function c82567800.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x825)
end
function c82567800.ncfilter(c)
	return  c:IsFaceup() and not c:IsSetCard(0x825)
end
function c82567800.ntcon(e,c,minc)
	if c==nil then return true end
	return minc==0 and c:IsLevelAbove(5) and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c82567800.cfilter,c:GetControler(),LOCATION_MZONE,0,1,nil) 
		and not Duel.IsExistingMatchingCard(c82567800.ncfilter,c:GetControler(),LOCATION_MZONE,0,1,nil)
end
function c82567800.drcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and Duel.GetTurnPlayer()==tp
end
function c82567800.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c82567800.drop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	local g=Duel.GetDecktopGroup(tp,1)
	local tc=g:GetFirst()
	Duel.Draw(p,d,REASON_EFFECT)
	if tc then
		Duel.ConfirmCards(1-tp,tc)
		Duel.BreakEffect()
		if tc:IsType(TYPE_TRAP) then
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_EXTRA_ATTACK)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e5:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	e5:SetValue(1)
	c:RegisterEffect(e5)
		else  return false
		end
	end
end
function c82567800.thcon(e,tp,eg,ep,ev,re,r,rp)
   return Duel.GetTurnPlayer()==e:GetHandler():GetControler() 
end
function c82567800.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
   if chk==0 then  return true  end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,tp,LOCATION_GRAVE)
end
function c82567800.thop(e,tp,eg,ep,ev,re,r,rp)
   Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT)
   Duel.ConfirmCards(1-tp,e:GetHandler())
   Duel.ShuffleHand(tp)
end