--空创神帝 凯路斯狮鹫
local s,id=GetID()
s.named_with_HighEvo=1

function s.HighEvo(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_HighEvo
end

function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end

function s.condition(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	local code=re:GetCode()
	return re:IsActiveType(TYPE_MONSTER) 
		and (code==EVENT_SUMMON_SUCCESS or code==EVENT_SPSUMMON_SUCCESS 
			 or code==EVENT_FLIP_SUMMON_SUCCESS or code==EVENT_FLIP)
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,id,0,TYPE_MONSTER+TYPE_EFFECT,3000,1600,8,RACE_WINDBEAST,ATTRIBUTE_LIGHT) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)

end

function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	
	if Duel.IsPlayerCanSpecialSummonMonster(tp,id,0,TYPE_MONSTER+TYPE_EFFECT,3000,1600,8,RACE_WINDBEAST,ATTRIBUTE_LIGHT) then
		c:AddMonsterAttribute(TYPE_EFFECT+TYPE_TRAP)
		if Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP)==0 then return end
		
		local e2=Effect.CreateEffect(c)
		e2:SetDescription(aux.Stringid(id,1))
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EFFECT_SEND_REPLACE)
		e2:SetRange(LOCATION_MZONE)
		e2:SetCountLimit(1)
		e2:SetTarget(s.reptg)
		e2:SetValue(s.repval)
		e2:SetOperation(s.repop)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e2)
		
		local dg=Duel.GetFieldGroup(tp,LOCATION_ONFIELD,LOCATION_ONFIELD)
		if dg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			local sg=dg:Select(tp,1,1,nil)
			local tc=sg:GetFirst()
			if tc then
				Duel.HintSelection(sg)
				local pre_code = tc:GetCode()
				local pre_loc = tc:GetLocation()
				local pre_seq = tc:GetSequence()
				
				if Duel.Destroy(sg,REASON_EFFECT)>0 then

					if pre_code==40020509  then
						if Duel.IsPlayerCanDraw(tp,2) then
							Duel.BreakEffect()
							Duel.Draw(tp,2,REASON_EFFECT)
						end
					end
				end
			end
		end
	end
end


function s.repfilter(c,tp)
	return c:IsControler(tp) and c:IsLocation(LOCATION_ONFIELD) 
		and s.HighEvo(c) and not c:IsReason(REASON_REPLACE)
		and c:IsReason(REASON_EFFECT) and c:GetReasonPlayer()==1-tp
end

function s.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(s.repfilter,1,nil,tp)
		and Duel.IsExistingMatchingCard(s.rmfilter,tp,LOCATION_GRAVE,0,1,nil) end
	if Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
		local g=eg:Filter(s.repfilter,nil,tp)
		for tc in aux.Next(g) do

		end
		return true
	end
	return false
end

function s.rmfilter(c)
	return s.HighEvo(c) and c:IsAbleToRemove()
end

function s.repval(e,c)
	return s.repfilter(c,e:GetHandlerPlayer())
end

function s.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,s.rmfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_EFFECT+REASON_REPLACE)
end
