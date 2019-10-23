--天下布武·魔神总司
function c9950068.initial_effect(c)
	 --link summon
	aux.AddLinkProcedure(c,nil,2,5,c9950068.lcheck)
	c:EnableReviveLimit()
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCountLimit(1,9950068+EFFECT_COUNT_CODE_DUEL)
	e1:SetCondition(c9950068.spcon)
	c:RegisterEffect(e1)
	 --aclimit
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e6:SetCode(EVENT_SPSUMMON_SUCCESS)
	e6:SetCountLimit(1,9950068)
	e6:SetOperation(c9950068.regop)
	c:RegisterEffect(e6)
	--half atk
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_SET_ATTACK_FINAL)
	e4:SetRange(LOCATION_MZONE)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetTargetRange(0,LOCATION_MZONE)
	e4:SetTarget(c9950068.atktg)
	e4:SetValue(c9950068.atkval)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_SET_DEFENSE_FINAL)
	e5:SetValue(c9950068.defval)
	c:RegisterEffect(e5)
	--spsummon bgm
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9950068.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
end
function c9950068.lcheck(g,lc)
	return g:IsExists(Card.IsLinkSetCard,1,nil,0x5ba5)
end
function c9950068.spcon(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandlerPlayer()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and ((Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0,nil)<Duel.GetFieldGroupCount(tp,LOCATION_MZONE,nil)) or(Duel.GetLP(1-tp)>Duel.GetLP(tp)))
end
function c9950068.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9950068,1))
end
function c9950068.regop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(0,1)
	e1:SetValue(c9950068.aclimit)
	e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN,2)
	Duel.RegisterEffect(e1,tp)
end 
function c9950068.aclimit(e,re,tp)
	return re:IsActiveType(TYPE_MONSTER)
end
function c9950068.atktg(e,c)
	return c~=e:GetHandler()
end
function c9950068.atkval(e,c)
	return math.ceil(c:GetAttack()/2)
end
function c9950068.defval(e,c)
	return math.ceil(c:GetDefense()/2)
end