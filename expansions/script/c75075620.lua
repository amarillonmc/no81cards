--入梦
function c75075620.initial_effect(c)
	-- 三选一
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c75075620.target)
	e1:SetOperation(c75075620.activate)
	c:RegisterEffect(e1)
	-- 盖放
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(c75075620.con2)
	e2:SetTarget(c75075620.tg2)
	e2:SetOperation(c75075620.op2)
	c:RegisterEffect(e2)
end
-- 1
function c75075620.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(aux.NecroValleyFilter(function(c)
				return c:IsSetCard(0x5754) and c:IsType(TYPE_MONSTER)
			end),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil)
			or Duel.IsExistingMatchingCard(function(c)
				return c:IsSetCard(0x5754) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
			end,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil)
			or Duel.GetFieldGroupCount(tp,LOCATION_FZONE,LOCATION_FZONE)>0
	end
	local options={}
	local op_desc={}
	if Duel.IsExistingMatchingCard(aux.NecroValleyFilter(function(c)
		return c:IsSetCard(0x5754) and c:IsType(TYPE_MONSTER)
	end),tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) then
		table.insert(options,0)
		table.insert(op_desc,aux.Stringid(75075620,0))
	end
	if Duel.IsExistingMatchingCard(function(c)
		return c:IsSetCard(0x5754) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	end,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE,0,1,nil) then
		table.insert(options,1)
		table.insert(op_desc,aux.Stringid(75075620,1))
	end
	if Duel.GetFieldGroupCount(tp,LOCATION_FZONE,LOCATION_FZONE)>0 then
		table.insert(options,2)
		table.insert(op_desc,aux.Stringid(75075620,2))
	end
	if #options==0 then return false end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EFFECT)
	local sel= Duel.SelectOption(tp,table.unpack(op_desc))
	e:SetLabel(options[sel+1])
	return true
end
function c75075620.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local op=e:GetLabel()
	if op==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(function(c) return c:IsSetCard(0x5754) and c:IsType(TYPE_MONSTER) end),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	elseif op==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.GetMatchingGroup(function(c) return c:IsSetCard(0x5754) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end,tp,LOCATION_HAND+LOCATION_GRAVE,0,nil)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	elseif op==2 then
		local fg=Duel.GetFieldGroup(tp,LOCATION_FZONE,LOCATION_FZONE)
		local ct=Duel.Destroy(fg,REASON_EFFECT)
		if ct>0 then
			Duel.Draw(tp,ct,REASON_EFFECT)
		end
	end
end
-- 2
function c75075620.filter2(c,tp)
	return c:IsPreviousControler(tp) and c:IsPreviousLocation(LOCATION_FZONE)
end
function c75075620.con2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c75075620.filter2,1,nil,tp) and not eg:IsContains(e:GetHandler())
end
function c75075620.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsSSetable() end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
end
function c75075620.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then Duel.SSet(tp,c) end
end
