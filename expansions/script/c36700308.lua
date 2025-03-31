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

--诺玛 火之晨曦
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,36700300,36700304)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,id)
	e1:SetCost(s.spcost)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_BECOME_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,id+1)
	e2:SetCondition(s.descon)
	e2:SetTarget(s.destg)
	e2:SetOperation(s.desop)
	c:RegisterEffect(e2)
	s.effect_2=e2

end

function s.spfilter(c)
	return c:IsSetCard(0xc50) and c:IsType(TYPE_MONSTER) and not c:IsPublic() and c:IsLocation(LOCATION_HAND)
end

function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_HAND,0,1,1,e:GetHandler())
	Duel.ConfirmCards(1-tp,g)
	e:SetLabelObject(g:GetFirst())
	Duel.ShuffleHand(tp)
end

function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end

function s.thfilter(c)
	return c:IsSetCard(0xc50) and c:IsAbleToHand()
end

function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=e:GetLabelObject()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
		if tc and (tc:IsCode(36700300) or tc:IsCode(36700304)) and Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil)
		 and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
			if #g>0 then
				Duel.SendtoHand(g,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,g)
			end
		end
	end
end

function s.descon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsContains(e:GetHandler())
end

function s.desfilter(c,tc)
	local sg=tc:GetColumnGroup()
	return c:IsType(TYPE_MONSTER) and sg:IsContains(c)
end

function s.desfilter2(c,seq)
	if seq<5 then
		local seq2=c:GetSequence()
		if seq2==5 then
			return c:IsType(TYPE_MONSTER) and seq==1
		elseif seq2==6 then
			return c:IsType(TYPE_MONSTER) and seq==3
		else
			return (c:IsType(TYPE_MONSTER) and math.abs(seq2-seq)==1)
			or (c:IsType(TYPE_SPELL+TYPE_TRAP) and c:GetSequence()==seq)
		end
	elseif seq==5 then
		local seq2=c:GetSequence()
		return c:IsType(TYPE_MONSTER) and seq2==1
	else
		return c:IsType(TYPE_MONSTER) and seq2==3
	end
end

function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(s.desfilter,tp,0,LOCATION_MZONE,1,nil,c) end
	local dg=Duel.GetMatchingGroup(s.desfilter,tp,0,LOCATION_MZONE,nil,c)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,dg,1,0,0)
	if chk==1 then
		return c
	end
end

function s.desop(e,tp,eg,ep,ev,re,r,rp,tsg)
	local c=e:GetHandler()
	if r==505 then
		c=tsg
	end

	local g=Duel.GetMatchingGroup(s.desfilter,tp,0,LOCATION_MZONE,nil,c)
	if #g>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local dc=g:Select(tp,1,1,nil):GetFirst()
		if dc then
			local seq=dc:GetSequence()
			Duel.Destroy(dc,REASON_EFFECT)
			if  Duel.IsExistingMatchingCard(s.desfilter2,tp,0,LOCATION_ONFIELD,1,nil,seq) then
				local tc=Duel.GetMatchingGroup(s.desfilter2,tp,0,LOCATION_ONFIELD,nil,seq)
				Duel.Destroy(tc,REASON_EFFECT)
			end
		end
	end
end
