-- 寄生兽的场地魔法卡
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	--atk limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetCondition(s.atcon)
	e2:SetValue(s.atlimit)
	c:RegisterEffect(e2)
	--cannot be target
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetRange(LOCATION_FZONE)
	e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetCondition(s.atcon)
	e3:SetTarget(s.atlimit)
	e3:SetValue(aux.tgoval)
	c:RegisterEffect(e3)
	--syz summon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,1))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCountLimit(1,id+1000)
	e4:SetCondition(s.xyzcon)
	e4:SetTarget(s.xyztg)
	e4:SetOperation(s.xyzop)
	c:RegisterEffect(e4)
end
function s.thfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xcf1)
		and c:IsAbleToHand()
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.thfilter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
function s.atfilter(c)
	return c:IsFaceup() and not c:IsSetCard(0xcf1)
end
function s.atcon(e)
	local tp=e:GetHandlerPlayer()
	return Duel.IsExistingMatchingCard(s.atfilter,tp,LOCATION_MZONE,0,1,nil)
end
function s.atlimit(e,c)
	return c:IsSetCard(0xcf1) and c:IsFaceup()
end
function s.xyzconfilter(c,tp)
	return c:IsFaceup()
end
function s.xyzcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.xyzconfilter,1,nil,tp)
end
function s.filter(c)
	return c:IsCanOverlay() and c:IsFaceup()
end
function s.fselect(sg,tp)
	local mg=Duel.GetMatchingGroup(s.filter,tp,LOCATION_MZONE,0,nil)
	return mg:CheckSubGroup(s.matfilter,1,#mg,tp,sg)
end
function s.matfilter(sg,tp,g)
	if sg:Filter(Card.IsSetCard,nil,0xcf1):GetCount()==0 then return false end
	return Duel.IsExistingMatchingCard(s.xyzfilter1,tp,LOCATION_EXTRA,0,1,nil,sg)
end
function s.xyzfilter1(c,mg)
	return c:IsXyzSummonable(mg,#mg,#mg)
end
function s.xyztg(e,tp,eg,ep,ev,re,r,rp,chk)
	local mg=Duel.GetMatchingGroup(s.filter,tp,LOCATION_MZONE,0,nil)
	if chk==0 then return mg:CheckSubGroup(s.fselect,1,mg:GetCount(),tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function s.xyzfilter2(c,mg)
	return mg:CheckSubGroup(s.gselect,1,#mg,c)
end
function s.gselect(sg,c)
	if sg:Filter(Card.IsSetCard,nil,0xcf1):GetCount()==0 then return false end
	return c:IsXyzSummonable(sg,#sg,#sg)
end
function s.xyzop(e,tp,eg,ep,ev,re,r,rp)
	local mg=Duel.GetMatchingGroup(s.filter,tp,LOCATION_MZONE,0,nil)
	local exg=Duel.GetMatchingGroup(s.xyzfilter2,tp,LOCATION_EXTRA,0,nil,mg)
	if exg:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=exg:Select(tp,1,1,nil)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local sg=mg:SelectSubGroup(tp,s.gselect,false,1,mg:GetCount(),tg:GetFirst())
		Duel.XyzSummon(tp,tg:GetFirst(),sg,#sg,#sg)
	end
end
