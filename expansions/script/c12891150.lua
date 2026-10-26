--超自然保护机关 疯狂犯罪者
local s,id,o=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	--summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,id+o)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(s.sumtg)
	e2:SetOperation(s.sumop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_SUMMON_PROC)
	e3:SetRange(0xff)
	e3:SetCondition(s.ntcon)
	e3:SetValue(SUMMON_TYPE_NORMAL)
	c:RegisterEffect(e3)
	e2:SetLabelObject(e3)
end
function s.filter(c)
	return (c:IsSetCard(0x6A7D) or c:IsLevelAbove(5) and c:IsAttribute(ATTRIBUTE_DARK)) and c:IsType(TYPE_MONSTER)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	Duel.RegisterEffect(e1,tp)
end
function s.ntcon(e,c,minc)
	if c==nil then return true end
	return minc==0 and Duel.CheckTribute(c,0) and c:IsLocation(LOCATION_HAND)
		and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
function s.sumfilter(c,res,se)
	return c:IsAttribute(ATTRIBUTE_DARK) and (c:IsSummonable(true,nil) or (res and c:IsLevelAbove(5) and c:IsSummonable(true,se)))
end
function s.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local res=Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)>0
	local se=e:GetLabelObject()
	if chk==0 then return Duel.IsExistingMatchingCard(s.sumfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil,res,se) end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function s.sumop(e,tp,eg,ep,ev,re,r,rp)
	local res=Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)>0
	local se=e:GetLabelObject()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local g=Duel.SelectMatchingCard(tp,s.sumfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil,res,se)
	local tc=g:GetFirst()
	if tc then
		local ne=nil
		if res and tc:IsLevelAbove(5) and tc:IsSummonable(true,se) and (not tc:IsSummonable(true,nil) or Duel.SelectYesNo(tp,aux.Stringid(id,2))) then
			ne=se
		end
		if tc:IsSummonable(true,ne) then
			Duel.Summon(tp,tc,true,ne)
		end
	end
end