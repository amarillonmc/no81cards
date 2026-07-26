--传国玉玺
--1200100
local s,id,o=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE+LOCATION_MZONE+LOCATION_REMOVED)
	e1:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
	e1:SetCountLimit(1)
	e1:SetHintTiming(0xFFFFFFF,0xFFFFFFF)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	--hand check1
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(id+1)
	e2:SetRange(0xff)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(0,1)
	c:RegisterEffect(e2)
	--hand check2
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(id)
	e3:SetRange(0xfd)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTargetRange(1,0)
	c:RegisterEffect(e3)
	if not s.global_check then
		s.global_check=true
		
		_SendtoHand=Duel.SendtoHand	
		function Duel.SendtoHand(tg,tp,reason,...)
			if tg==nil or (aux.GetValueType(tg)=="Group" and #tg<=0) then
				return _SendtoHand(tg,tp,reason,...)
			end
			if aux.GetValueType(tg)=="Group" and #tg==1 then tg=tg:GetFirst() end
			if tp==nil then
				if aux.GetValueType(tg)=="Card" then
					tp=tg:GetControler()
				elseif aux.GetValueType(tg)=="Group" then
					tp=tg:GetFirst():GetControler()
				end
			end
			if tp==nil then return _SendtoHand(tg,tp,reason,...) end
			--加入自己手卡
			if Duel.IsPlayerAffectedByEffect(tp,id)
				and Duel.IsExistingMatchingCard(s.thfilter,tp,0xfd,0,1,nil) then
				
				if aux.GetValueType(tg)=="Card" then
					if not tg:IsCode(id) and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
					
						Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(id,3))
						if tg:IsFacedown() then Duel.ConfirmCards(1-tp,tg) end
						Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
						local sg=Duel.SelectMatchingCard(tp,s.thfilter,tp,0xfd,0,1,1,nil)
						tg=sg
					end
				elseif aux.GetValueType(tg)=="Group" then
					local cg=tg:Filter(s.idfilter,nil)
					if #cg>0 and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
						Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(id,3))
						if #cg>1 then
							Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
							local cg=cg:Select(tp,1,1,nil)
						end
						if cg:GetFirst():IsFacedown() then
							Duel.ConfirmCards(1-tp,cg:GetFirst())
							Duel.ConfirmCards(tp,cg:GetFirst())
						end
						tg:Sub(cg)
						Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
						local sg=Duel.SelectMatchingCard(tp,s.thfilter,tp,0xfd,0,1,1,nil)
						tg:Merge(sg)
					end
				end
			end
			--加入对面手卡
			if Duel.IsPlayerAffectedByEffect(tp,id+1)
				and Duel.IsExistingMatchingCard(s.thfilter,tp,0,0xff,1,nil) then
				if aux.GetValueType(tg)=="Card" then
					if not tg:IsCode(id) and Duel.SelectYesNo(1-tp,aux.Stringid(id,2)) then
						Duel.Hint(HINT_OPSELECTED,tp,aux.Stringid(id,3))
						if tg:IsFacedown() then Duel.ConfirmCards(tp,tg) end
						Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_ATOHAND)
						local sg=Duel.SelectMatchingCard(1-tp,s.thfilter,1-tp,0xff,0,1,1,nil)
						tg=sg
					end
				elseif aux.GetValueType(tg)=="Group" then
					local cg=tg:Filter(s.idfilter,nil)
					if #cg>0 and Duel.SelectYesNo(1-tp,aux.Stringid(id,2)) then
						Duel.Hint(HINT_OPSELECTED,tp,aux.Stringid(id,3))
						if #cg>1 then
							Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_OPERATECARD)
							local cg=cg:Select(1-tp,1,1,nil)
						end
						if cg:GetFirst():IsFacedown() then
							Duel.ConfirmCards(1-tp,cg:GetFirst())
							Duel.ConfirmCards(tp,cg:GetFirst())
						end
						tg:Sub(cg)
						Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_ATOHAND)
						local sg=Duel.SelectMatchingCard(1-tp,s.thfilter,1-tp,0xff,0,1,1,nil)
						tg:Merge(sg)
					end
				end
			end
			return _SendtoHand(tg,tp,reason,...)
		end
		
		_Draw=Duel.Draw
		function Duel.Draw(tp,count,reason)
			if count<=0 then return _Draw(tp,count,reason) end
			--加入自己手卡
			if Duel.IsPlayerAffectedByEffect(tp,id)
				and Duel.IsExistingMatchingCard(s.thfilter,tp,0xfd,0,1,nil) 
				and Duel.SelectYesNo(tp,aux.Stringid(id,1))	then
						
				Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(id,3))
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
				local sg=Duel.SelectMatchingCard(tp,s.thfilter,tp,0xfd,0,1,1,nil)
				Duel.SendtoHand(sg,tp,reason)
				count=count-1
			end
			--加入对面手卡
			if Duel.IsPlayerAffectedByEffect(tp,id+1)
				and Duel.IsExistingMatchingCard(s.thfilter,tp,0,0xff,1,nil) 
				and Duel.SelectYesNo(1-tp,aux.Stringid(id,2))	then
						
				Duel.Hint(HINT_OPSELECTED,tp,aux.Stringid(id,3))
				Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_ATOHAND)
				local sg=Duel.SelectMatchingCard(1-tp,s.thfilter,1-tp,0xff,0,1,1,nil)
				Duel.SendtoHand(sg,tp,reason)
				count=count-1
			end
			
			return _Draw(tp,count,reason)
		end
	end
end
function s.thfilter(c)
	return c:IsCode(id) and c:IsAbleToHand()
end
function s.idfilter(c)
	return not c:IsCode(id)
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsFaceup() or c:GetLocation()==LOCATION_HAND end
end
function s.filter(c,tc)	
	return c==tc
end
function s.aclimit(e,re,tp)
	return (not re:GetHandler():IsCode(id)) or re:GetActivateLocation()==LOCATION_HAND
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,0))
	local tc=e:GetHandler()
	local ag=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_MZONE+LOCATION_REMOVED,0,1,1,nil,tc)
	if ag:GetCount()>0 then
	
		local e1=Effect.CreateEffect(tc)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_CANNOT_ACTIVATE)
		e1:SetTargetRange(1,0)
		e1:SetValue(s.aclimit)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		
		Duel.SendtoHand(ag,1-tp,REASON_EFFECT)
		Duel.ShuffleHand(tp)
		Duel.ConfirmCards(tp,ag)
	end
end