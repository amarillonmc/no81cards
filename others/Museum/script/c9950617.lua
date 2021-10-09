--魁札尔·科亚特尔 -火力全开
function c9950617.initial_effect(c)
	 --fusion summon
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0xba5,0xbc8),7,true)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.fuslimit)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c9950617.hspcon)
	e2:SetOperation(c9950617.hspop)
	c:RegisterEffect(e2)
 --indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_ONFIELD,0)
	e2:SetValue(c9950617.indct)
	c:RegisterEffect(e2)
--atk/def
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_UPDATE_ATTACK)
	e4:SetValue(c9950617.atkvalue)
	c:RegisterEffect(e4)
 --cannot activate
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_ACTIVATE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0,1)
	e3:SetValue(c9950617.aclimit)
	c:RegisterEffect(e3)
 --disable effect
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_SOLVING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetOperation(c9950617.disop)
	c:RegisterEffect(e1)
	 --spsummon bgm
	 local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9950617.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
end
function c9950617.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9950617,0))
 Duel.Hint(HINT_SOUND,0,aux.Stringid(9950617,1))
end
function c9950617.hspfilter(c,tp,sc)
	return c:IsFusionCode(9950112) and c:IsLevel(10) and c:IsControler(tp) and Duel.GetLocationCountFromEx(tp,tp,c,sc)>0 and c:IsCanBeFusionMaterial(sc,SUMMON_TYPE_SPECIAL)
end
function c9950617.hspcon(e,c)
	if c==nil then return true end
	return Duel.CheckReleaseGroup(c:GetControler(),c9950617.hspfilter,1,nil,c:GetControler(),c)
end
function c9950617.hspop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.SelectReleaseGroup(tp,c9950617.hspfilter,1,1,nil,tp,c)
	c:SetMaterial(g)
	Duel.Release(g,REASON_COST)
end
function c9950617.indct(e,re,r,rp)
	if bit.band(r,REASON_BATTLE+REASON_EFFECT)~=0 then
		return 1
	else return 0 end
end
function c9950617.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)==LOCATION_REMOVED+LOCATION_GRAVE and re:IsActiveType(TYPE_MONSTER) and rp==1-tp then
		Duel.NegateEffect(ev)
	end
end
function c9950617.rmfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER)
end
function c9950617.atkvalue(e,c)
	return Duel.GetMatchingGroupCount(c9950617.rmfilter,c:GetControler(),0,LOCATION_REMOVED+LOCATION_GRAVE,nil)*500
end
function c9950617.acfilter(c,code)
	return c:IsFaceup() and c:IsCode(code)
end
function c9950617.aclimit(e,re,tp)
	return Duel.IsExistingMatchingCard(c9950617.acfilter,e:GetHandlerPlayer(),LOCATION_REMOVED+LOCATION_GRAVE,LOCATION_REMOVED+LOCATION_GRAVE,1,nil,re:GetHandler():GetCode())
end