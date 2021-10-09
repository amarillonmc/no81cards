--Beast-Ⅰ-「人王」·Goetia
function c9950996.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,c9950996.matfilter,5)
	--spsummon condition
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(aux.linklimit)
	c:RegisterEffect(e0)
	--win
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetCondition(c9950996.wincon)
	e4:SetOperation(c9950996.winop)
	c:RegisterEffect(e4)
	 --spsummon bgm
	 local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9950996.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
end
function c9950996.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SOUND,0,aux.Stringid(9950996,0))
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9950996,1))
end
function c9950996.matfilter(c)
	return c:GetSummonLocation()==LOCATION_EXTRA and c:IsSetCard(0xba5)
end
function c9950996.wincon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c9950996.winop(e,tp,eg,ep,ev,re,r,rp)
	local WIN_REASON_CREATORGOD=0x13
	local p=e:GetHandler():GetSummonPlayer()
	Duel.Win(p,WIN_REASON_CREATORGOD)
end