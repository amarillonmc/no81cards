--共生试验体 鳞肤魑魅
function c9910885.initial_effect(c)
	aux.AddCodeList(c,9910871)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,c9910885.ffilter,3,true)
	--spsummon condition
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(c9910885.splimit)
	c:RegisterEffect(e0)
	--atk & def
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c9910885.atkval)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e2)
	--set
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c9910885.setcon)
	e3:SetTarget(c9910885.settg)
	e3:SetOperation(c9910885.setop)
	c:RegisterEffect(e3)
end
function c9910885.ffilter(c,fc,sub,mg,sg)
	return not sg or sg:FilterCount(aux.TRUE,c)==0 or not sg:IsExists(Card.IsRace,1,c,c:GetRace())
end
function c9910885.splimit(e,se,sp,st)
	return st&SUMMON_TYPE_FUSION~=SUMMON_TYPE_FUSION or (se and se:GetHandler():IsCode(9910871))
end
function c9910885.atkfilter(c)
	return c:IsFaceup() and c:GetRace()~=0
end
function c9910885.atkval(e,c)
	local g=Duel.GetMatchingGroup(c9910885.atkfilter,c:GetControler(),LOCATION_MZONE,LOCATION_MZONE,nil)
	local ct=g:GetClassCount(Card.GetRace)
	return ct*200
end
function c9910885.setcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp
end
function c9910885.setfilter(c)
	return aux.IsCodeListed(c,9910871) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable()
end
function c9910885.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9910885.setfilter,tp,LOCATION_DECK,0,1,nil) end
	e:GetHandler():RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(9910885,0))
end
function c9910885.setop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,c9910885.setfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SSet(tp,g)
	end
end
