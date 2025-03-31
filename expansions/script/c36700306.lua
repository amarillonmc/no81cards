--[[
本lua的作者为藜奴儿，如果测试出bug请联系QQ：1502939196

未经允许不支持任何人的任何形式的修改，源数。如有需要请联系作者，而不是私自找人代为修改。
本人对于本lua的任何bug修改、源数和适配后来卡片均为免费，并且追诉期无限。

但是如果使用者私自修改了lua，不论是bug修复还是源数效果，本人对此lua都不会再提供任何形式的支持。
一旦发现任何其他人对本lua进行了任何形式的修改，本人首先自愿放弃此lua除必要署名权以外的所有权利，
同时再也会不承担对此lua的任何维护与后续适配，包括但不限于任何形式的bug修复、效果源数。

如果您想要修改此lua，可以先联系本人，本人会在第一时间进行回复。
并且我承诺，若本人在2天内没有回复您，上述注意事项可作废，您可以直接修改此lua，而后续debug与适配仍然由我来进行。

如果您对本lua有任何疑问，请联系本人，本人会在第一时间进行回复。
如果您对本lua有任何建议，请联系本人，本人会在第一时间进行处理。
]]

--恺撒 火之晨曦
local s,id,o=GetID()
function s.initial_effect(c)
	--special summon and search/send
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON+CATEGORY_SEARCH+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	--special summon when targeted
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_BECOME_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,id+1)
	e2:SetCondition(s.spcon2)
	e2:SetTarget(s.sptg2)
	e2:SetOperation(s.spop2)
	c:RegisterEffect(e2)
	s.effect_2=e2

end

function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(tp) and chkc:IsAbleToHand() end
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToHand,tp,LOCATION_ONFIELD,0,1,nil)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,Card.IsAbleToHand,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end

function s.thfilter(c,tc)
	if tc:IsType(TYPE_MONSTER) then
		return c:IsSetCard(0xc50) and not c:IsType(TYPE_MONSTER) and (c:IsAbleToHand() or c:IsAbleToGrave())
	elseif tc:IsType(TYPE_SPELL) then
		return c:IsSetCard(0xc50) and not c:IsType(TYPE_SPELL) and (c:IsAbleToHand() or c:IsAbleToGrave())
	else
		return c:IsSetCard(0xc50) and not c:IsType(TYPE_TRAP) and (c:IsAbleToHand() or c:IsAbleToGrave())
	end
end

function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local c=e:GetHandler()
	if not tc:IsRelateToEffect(e) or not c:IsRelateToEffect(e) then return end
	
	if Duel.SendtoHand(tc,nil,REASON_EFFECT)>0 and tc:IsLocation(LOCATION_HAND) then
		if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
			local g=Duel.GetMatchingGroup(s.thfilter,tp,LOCATION_DECK,0,nil,tc)
			if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
				Duel.BreakEffect()
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
				local sg=g:Select(tp,1,1,nil)
				local sc=sg:GetFirst()
				local b1=sc:IsAbleToHand()
				local b2=sc:IsAbleToGrave()
				local op=0
				if b1 and b2 then
					op=Duel.SelectOption(tp,aux.Stringid(id,4),aux.Stringid(id,5))
				elseif b1 then
					op=0
				else
					op=1
				end
				if op==0 then
					Duel.SendtoHand(sc,nil,REASON_EFFECT)
					Duel.ConfirmCards(1-tp,sc)
				else
					Duel.SendtoGrave(sc,REASON_EFFECT)
				end
			end
		end
	end
end

function s.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsContains(e:GetHandler())
end

function s.spfilter(c,e,tp)
	return c:IsSetCard(0xc50) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

function s.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end

function s.spop2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
