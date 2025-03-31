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

--芬格尔 火之晨曦
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,36700308)
	--coin
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_COIN+CATEGORY_DRAW+CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)

	e2:SetCountLimit(1,id)
	e2:SetTarget(s.cointg)
	e2:SetOperation(s.coinop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,2))
	e4:SetCategory(CATEGORY_TODECK+CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_BECOME_TARGET)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,id+1)
	e4:SetCondition(s.thcon)
	e4:SetTarget(s.thtg)
	e4:SetOperation(s.thop)
	c:RegisterEffect(e4)
	s.effect_2=e4

end
function s.cointg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_COIN,nil,0,tp,1)
end
function s.wchfilter(c)
	return not c:IsPublic()
end
function s.chkfilter(c)
	return c:IsFaceupEx() and c:IsCode(36700308)
end

function s.spfilter2(c,e,tp)
	return c:IsSetCard(0xc50) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,1-tp)
end
function s.coinop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local res=-1
	if Duel.IsExistingMatchingCard(s.chkfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,1,nil) then
		local b1=Duel.IsExistingMatchingCard(s.wchfilter,tp,0,LOCATION_HAND,1,nil) and Duel.IsPlayerCanDraw(tp,1)
		local b2=Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,LOCATION_HAND,0,1,nil)
		if b1 and not b2 then
			Duel.Hint(HINT_OPSELECTED,1-tp,60)
			res=1
		end
		if b2 and not b1 then
			Duel.Hint(HINT_OPSELECTED,1-tp,61)
			res=0
		end
		if b1 and b2 then
			res=aux.SelectFromOptions(tp,
				{b1,60,1},
				{b2,61,0})
		end
	else
		res=Duel.TossCoin(tp,1)
	end
	if res==1 then
		local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
		if #g>0 then
			Duel.ConfirmCards(tp,g)
			Duel.Draw(tp,1,REASON_EFFECT)
		end
	elseif res==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,Card.IsAbleToGrave,tp,LOCATION_HAND,0,1,1,nil)
		if #g>0 then
			Duel.SendtoGrave(g,REASON_EFFECT)
		end
	end
end

function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsContains(e:GetHandler())
end

function s.thfilter(c,e,tp)
	return c:IsCode(36700308) and (c:IsAbleToHand() or c:IsCanBeSpecialSummoned(e,0,tp,false,false))
end

function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
        return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK|LOCATION_GRAVE,0,1,nil,e,tp)
    end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
end

function s.thop(e,tp)
	local c=e:GetHandler()
	if Duel.SendtoDeck(c,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
		local g=Duel.GetMatchingGroup(s.thfilter,tp,LOCATION_DECK|LOCATION_GRAVE,0,nil,e,tp)
		if #g>0 then
			local tc=g:Select(tp,1,1,nil):GetFirst()
			if not(tc:IsCanBeSpecialSummoned(e,0,tp,false,false)or tc:IsAbleToHand()) then
				return
			end
			if tc then
				if tc:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.SelectYesNo(tp,aux.Stringid(id,3)) then
					Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
				else
					Duel.SendtoHand(tc,nil,REASON_EFFECT)
				end
			end
		end
	end
end
