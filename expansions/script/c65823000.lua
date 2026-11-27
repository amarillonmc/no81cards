-- 现代最强-五条悟
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,65823000)
	c:SetUniqueOnField(1,0,65823000)
	--①：丢弃1张其他手卡，从手卡特殊召唤
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(s.spcon)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	e1:SetValue(SUMMON_VALUE_SELF)
	c:RegisterEffect(e1)
	--①的后续：那个场合可以把1张记述卡名的魔法卡加入手卡
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(s.eqcon)
	e2:SetOperation(s.eqop)
	e2:SetLabelObject(e1)
	c:RegisterEffect(e2)
end
--丢弃用的手卡：不能是这张卡自己
function s.disfilter(c,ec)
	return c~=ec and c:IsDiscardable()
end
function s.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.disfilter,tp,LOCATION_HAND,0,1,nil,c)
end
--在召唤手续里选要丢弃的卡（取消则整个特殊召唤取消）
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local g=Duel.GetMatchingGroup(s.disfilter,tp,LOCATION_HAND,0,nil,c)
	if #g<=0 then return false end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local tc=g:SelectUnselect(nil,tp,false,true,1,1)
	if tc then
		e:SetLabelObject(tc)
		return true
	end
	return false
end
function s.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local tc=e:GetLabelObject()
	if tc then
		Duel.SendtoGrave(tc,REASON_COST+REASON_DISCARD)
	end
	e:SetLabel(1)
end
function s.thfilter(c,ec)
	return aux.IsCodeListed(c,65823000) and c:IsAbleToHand() and c:IsType(TYPE_SPELL)
end
function s.eqcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SPECIAL+SUMMON_VALUE_SELF
end
function s.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(s.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,nil)
	if e:GetLabelObject():GetLabel()==1 and #g>0 and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local tc=g:Select(tp,1,1,nil):GetFirst()
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
