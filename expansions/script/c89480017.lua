--极彩蛇的慈悲
local s,id,o=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsRace,RACE_REPTILE))
	e2:SetValue(300)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	c:RegisterEffect(e3)
	local custom_code=s.RegisterMergedDelayedEvent_ToSingleCard(c,id,EVENT_TO_GRAVE)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(custom_code)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTarget(s.destg)
	e2:SetOperation(s.desop)
	c:RegisterEffect(e2)
end
function s.RegisterMergedDelayedEvent_ToSingleCard(c,code,events)
	local g=Group.CreateGroup()
	g:KeepAlive()
	local g2=Group.CreateGroup()
	g2:KeepAlive()
	local g3=Group.CreateGroup()
	g3:KeepAlive()
	local mt=getmetatable(c)
	local seed=0
	if type(events) == "table" then 
		for _, event in ipairs(events) do
			seed = seed + event 
		end 
	else 
		seed = events
	end 
	while(mt[seed]==true)
	do 
		seed = seed + 1 
	end
	mt[seed]=true 
	local event_code_single = (code ~ (seed << 16)) | EVENT_CUSTOM
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(events)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetRange(LOCATION_SZONE)
	e1:SetLabel(event_code_single)
	e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
						g:Merge(eg:Filter(s.desfilter,nil,tp,LOCATION_HAND))
						g2:Merge(eg:Filter(s.desfilter,nil,tp,LOCATION_DECK+LOCATION_EXTRA))
						g3:Merge(eg:Filter(s.desfilter,nil,tp,LOCATION_ONFIELD))
						if Duel.GetCurrentChain()==0 and not Duel.CheckEvent(EVENT_CHAIN_END) then
							local _eg=g:Clone()
							local _eg2=g2:Clone()
							local _eg3=g3:Clone()
							local sum=0
							if #g>0 then sum=sum+1 end
							if #g2>0 then sum=sum+2 end
							if #g3>0 then sum=sum+4 end
							if sum>0 then
								Duel.RaiseEvent(_eg+_eg2+_eg3,e:GetLabel(),re,sum,rp,ep,ev)
							end  
							g:Clear()
							g2:Clear()
							g3:Clear()
						end
					end)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_CHAIN_END)
	e2:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
						local _eg=g:Clone()
						local _eg2=g2:Clone()
						local _eg3=g3:Clone()
						local sum=0
						if #g>0 then sum=sum|0x1 end
						if #g2>0 then sum=sum|0x2 end
						if #g3>0 then sum=sum|0x4 end
						if sum>0 then
							Duel.RaiseEvent(_eg+_eg2+_eg3,e:GetLabel(),re,sum,rp,ep,ev)
						end  
						g:Clear()
						g2:Clear()
						g3:Clear()
					end)
	c:RegisterEffect(e2)
	return event_code_single
end
function s.desfilter(c,tp,loc)
	return c:IsControler(tp) and c:IsRace(RACE_REPTILE) and c:IsType(TYPE_MONSTER) and c:IsPreviousLocation(loc)
end
function s.cfilter(c,code)
	return c:IsCode(code) and c:IsFaceupEx()
end
function s.sumfilter(c)
	return c:IsSummonableCard() and (c:IsSummonable(true,nil) or c:IsMSetable(true,nil))
end
function s.spfilter(c,e,tp)
	return c:IsRace(RACE_REPTILE) and c:IsLevelBelow(4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,1,nil,c:GetCode())
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local b1=r&0x1>0 and Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c) and c:GetFlagEffect(id)==0
	local b2=r&0x2>0 and Duel.IsExistingMatchingCard(s.sumfilter,tp,LOCATION_HAND,0,1,nil) and c:GetFlagEffect(id+1)==0
	local b3=r&0x4>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) and c:GetFlagEffect(id+2)==0
	if chk==0 then return b1 or b2 or b3 end
	local cat=0
	if b1 then
		cat=cat+CATEGORY_TOHAND
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,PLAYER_ALL,LOCATION_ONFIELD)
	end
	if b2 then
		cat=cat+CATEGORY_SUMMON
		Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,tp,LOCATION_HAND)
	end
	if b3 then
		cat=cat+CATEGORY_SPECIAL_SUMMON
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
	end
	e:SetCategory(cat)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local b1=r&0x1>0 and Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c) and c:GetFlagEffect(id)==0
	local b2=r&0x2>0 and Duel.IsExistingMatchingCard(s.sumfilter,tp,LOCATION_HAND,0,1,nil) and c:GetFlagEffect(id+1)==0
	local b3=r&0x4>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) and c:GetFlagEffect(id+2)==0
	if b1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
		local g1=Duel.SelectMatchingCard(tp,Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,c)
		Duel.SendtoHand(g1,nil,REASON_EFFECT)
		c:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	end
	if b2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
		local g2=Duel.SelectMatchingCard(tp,s.sumfilter,tp,LOCATION_HAND,0,1,1,nil)
		local tc=g2:GetFirst()
		if tc then
			local s1=tc:IsSummonable(true,nil)
			local s2=tc:IsMSetable(true,nil)
			if (s1 and s2 and Duel.SelectPosition(tp,tc,POS_FACEUP_ATTACK+POS_FACEDOWN_DEFENSE)==POS_FACEUP_ATTACK) or not s2 then
				Duel.Summon(tp,tc,true,nil)
			else
				Duel.MSet(tp,tc,true,nil)
			end
			c:RegisterFlagEffect(id+1,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
		end
	end
	if b3 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g3=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
		Duel.SpecialSummon(g3,0,tp,tp,false,false,POS_FACEUP)
		c:RegisterFlagEffect(id+2,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	end
end
