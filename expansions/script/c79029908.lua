--艾雅法拉·珊瑚海岸收藏-夏卉
function c79029908.initial_effect(c)
	c:EnableReviveLimit()
	-- 
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE_START+PHASE_STANDBY)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCountLimit(1,79029908+EFFECT_COUNT_CODE_DUEL)
	e1:SetOperation(c79029908.reop)
	c:RegisterEffect(e1)   
	--win
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetOperation(c79029908.winop)
	c:RegisterEffect(e2) 
end
function c79029908.reop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.SelectEffectYesNo(tp,c) then 
	Debug.Message("请您给予我更多的指导，前辈~")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029908,1))
	Duel.Hint(HINT_MESSAGE,0,aux.Stringid(79029908,0))  
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetRange(0xff)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetCountLimit(1)
	e1:SetReset(RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,2)
	e1:SetCondition(c79029908.spcon)
	e1:SetOperation(c79029908.spop)
	e1:SetLabel(0)
	c:RegisterEffect(e1)
	end
end
function c79029908.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c79029908.spop(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabel()
	e:GetHandler():SetTurnCounter(ct+1)
	if ct==1 then
	Duel.SpecialSummon(e:GetHandler(),0,tp,tp,true,true,POS_FACEUP)
	else e:SetLabel(1) end
end
function c79029908.winop(e,tp,eg,ep,ev,re,r,rp)
	local WIN_REASON_EYJAFJALLA=0x1
	local p=e:GetHandler():GetOwner()
	Debug.Message("为什么要这样彼此争斗不休呢......")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029908,2))
	Duel.Hint(HINT_MESSAGE,0,aux.Stringid(79029908,0))  
	Duel.Win(p,WIN_REASON_EYJAFJALLA)
end







