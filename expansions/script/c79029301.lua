--诗怀雅·0011™制造收藏-富贵荣华
function c79029301.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_FIRE),8,2)
	c:EnableReviveLimit()
	--add code
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_ADD_CODE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetValue(79029060)
	c:RegisterEffect(e2)  
	--draw
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,79029301)
	e1:SetCost(c79029301.lzcost)
	e1:SetCondition(c79029301.lzcon)
	e1:SetOperation(c79029301.lzop)
	c:RegisterEffect(e1)  
	--ov
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(79029301,0))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,09029301)
	e3:SetCost(c79029301.ovcost)
	e3:SetOperation(c79029301.ovop)
	c:RegisterEffect(e3)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetDescription(aux.Stringid(79029301,1))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c79029301.sptg)
	e3:SetOperation(c79029301.spop)
	c:RegisterEffect(e3)
end
function c79029301.lzcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function c79029301.lzcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,2000) end
	local lp=Duel.GetLP(tp)
	local t={}
	local f=math.floor((lp)/2000)
	local l=1
	while l<=f and l<=20 do
		t[l]=l*2000
		l=l+1
	end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(17078030,0))
	local announce=Duel.AnnounceNumber(tp,table.unpack(t))
	Duel.PayLPCost(tp,announce)
	e:SetLabel(announce)
end
function c79029301.lzop(e,tp,eg,ep,ev,re,r,rp)
	local x=e:GetLabel()
	local f=math.floor(x/2000)  
	Duel.Draw(tp,f,REASON_EFFECT)
	Debug.Message("好呀，战斗和商业是一样的，风险与回报并存！")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029301,2))
end
function c79029301.ovcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)>0 end
	local g=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
	Duel.ConfirmCards(1-tp,g)
end
function c79029301.ovop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetDecktopGroup(1-tp,Duel.GetFieldGroupCount(tp,LOCATION_HAND,0))
	Duel.Overlay(e:GetHandler(),g)
	Debug.Message("该沽出了！")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029301,4))
end
function c79029301.spfil(c,e,tp,x)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsSetCard(0xa900) and c:IsLevelBelow(x)
end
function c79029301.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local x=e:GetHandler():GetOverlayCount()
	if chk==0 then return Duel.IsExistingMatchingCard(c79029301.spfil,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_DECK,0,1,nil,e,tp,x) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Debug.Message("可要好好听从我的指挥！")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029301,3))
	local g=Duel.SelectMatchingCard(tp,c79029301.spfil,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_DECK,0,1,1,nil,e,tp,x)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,tp,0)
end
function c79029301.spop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
end


