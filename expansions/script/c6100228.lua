--朦雨的雨影·希
local s,id,o=GetID()
function s.initial_effect(c)
	--①：特召额外怪兽
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND+LOCATION_MZONE)
	e1:SetCountLimit(1,id)
	e1:SetCost(s.spcost)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	--②：自我苏生
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,id+1)
	e2:SetCondition(s.rescon)
	e2:SetTarget(s.restg)
	e2:SetOperation(s.resop)
	c:RegisterEffect(e2)
end

--字段：朦雨
function s.costfilter(c)
	return c:IsSetCard(0x613) and c:IsAbleToGraveAsCost()
end

function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then 
		return c:IsAbleToGraveAsCost() 
			and Duel.IsExistingMatchingCard(s.costfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,c)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,s.costfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,c)
	g:AddCard(c)
	Duel.SendtoGrave(g,REASON_COST)
end

function s.spfilter(c)
	return c:IsSetCard(0x613) and (c:IsLinkBelow(2) or c:IsLevel(5))
end

function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_EXTRA,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end

function s.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_EXTRA,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		-- 当作连接召唤特殊召唤
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		tc:CompleteProcedure()
	end
end

function s.rescon(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	return ep==tp and re:IsActiveType(TYPE_MONSTER) and not rc:IsType(TYPE_LINK)
		and re:GetActivateLocation()==LOCATION_MZONE
end

function s.restg(e,tp,eg,ep,ev,re,r,rp,chk)
	-- 检查是否有连接怪兽指向的格子
	local zone=Duel.GetLinkedZone(tp)
	if chk==0 then return zone~=0 and Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,zone)>0 
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,zone) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end

function s.resop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local zone=Duel.GetLinkedZone(tp)
	if c:IsRelateToEffect(e) and zone~=0 and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP,zone)~=0 then
		-- 离场回持有者卡组
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(id,2))
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
		e1:SetValue(LOCATION_DECK)
		e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
		c:RegisterEffect(e1,true)
	end
end