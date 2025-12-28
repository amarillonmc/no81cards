--对外星人次元障壁
local s,id,o=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetHintTiming(0,TIMING_DRAW_PHASE+TIMING_END_PHASE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	--
	if not Super_Earthling_Initialization then
		Super_Earthling_Initialization=true
		--handtrap check
		local ge01=Effect.CreateEffect(c)
		ge01:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge01:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		ge01:SetCode(EVENT_ADJUST)
		ge01:SetOperation(s.adjustop)
		Duel.RegisterEffect(ge01,0)
	end
	if not s.global_check then
		s.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAINING)
		ge1:SetOperation(s.chkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function s.filter(c)
	return c:IsSetCard(0xdce) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
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
	if Super_Earthling_player_table[tp]==1 then
		local c=e:GetHandler()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_CANNOT_ACTIVATE)
		e1:SetTargetRange(0,1)
		e1:SetCondition(s.accon)
		e1:SetValue(s.aclimit)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
end
function s.isactivate(tp,code)
	local codetable=table.pack(Duel.GetFlagEffectLabel(tp,id+10000+100))
	for _, v in pairs(codetable) do
		if v==code then
			return true
		end
	end
	return false
end
function s.chkop(e,tp,eg,ep,ev,re,r,rp)
	local code=re:GetHandler():GetCode()
	if s.isactivate(rp,code) then
		Duel.RegisterFlagEffect(1-rp,id+10000+200,RESET_PHASE+PHASE_END,0,2)
	else
		Duel.RegisterFlagEffect(rp,id+10000+100,RESET_PHASE+PHASE_END,0,1,code)
	end
end
function s.accon(e)
	return e:GetHandler():GetOverlayCount()>0
end
function s.aclimit(e,re,tp)
	return s.isactivate(tp,re:GetHandler():GetCode())
end

---------------------------handtrap check-------------------------------

function s.getsetcard(c)
	local setcard={}
	for i=0x1,0xfff do
		if c:IsSetCard(i) then setcard[#setcard+1]=i end
	end
	return setcard
end
function s.effect_equal(e1,e2)
	if not e1 or not e2 then return false end
	local tg1=e1:GetTarget()
	local tg2=e2:GetTarget()
	local op1=e1:GetOperation()
	local op2=e2:GetOperation()
	local tg_equal=false
	local op_equal=false
	if not tg1 and not tg2 then
		tg_equal=true
	end
	if tg1 and tg2 and tg1==tg2 then
		tg_equal=true
	end
	if not op1 and not op2 then
		op_equal=true
	end
	if op1 and op2 and op1==op2 then
		op_equal=true
	end
	return tg_equal and op_equal
end 
function s.adjustop(e,tp,eg,ep,ev,re,r,rp)
	--
	if not Super_Earthling_Handtrap_globle_check then
		Super_Earthling_Handtrap_globle_check=true
		--setup table
		Super_Earthling_Handtrap_codetable={}
		Super_Earthling_one_act_table={}
		Super_Earthling_setcard_table={}
		--gain group
		local g=Duel.GetFieldGroup(0,0xff,0xff)
		local cisdiscardable=Card.IsDiscardable
		local cisabletograveascost=Card.IsAbleToGraveAsCost
		--
		local handtrap_check_card=nil
		local handtrap_boolean=false
		local handtrap_sp_boolean=false
		Card.IsDiscardable=function(card,reason)
			if card==handtrap_check_card then 
				handtrap_boolean=true
			end
			return cisdiscardable(card,reason)
		end
		Card.IsAbleToGraveAsCost=function(card)
			if card==handtrap_check_card then 
				handtrap_boolean=true
			end
			return cisabletograveascost(card)
		end
		--
		for tc in aux.Next(g) do
			if not Super_Earthling_Handtrap_codetable[tc:GetOriginalCode()] and not Super_Earthling_setcard_table[tc:GetOriginalCode()] then
			--
			local setcard=s.getsetcard(tc)
			Super_Earthling_setcard_table[tc:GetOriginalCode()]=setcard
			--
			local handtrap_count=0
			local act_count=0
			local effect_front=nil
			local boolean=tc:IsOriginalEffectProperty(
				function(effect)
					if effect and (effect:GetCost() and tc:IsType(TYPE_MONSTER) and effect:IsHasRange(LOCATION_HAND) and bit.band(effect:GetType(),EFFECT_TYPE_IGNITION+EFFECT_TYPE_QUICK_F+EFFECT_TYPE_QUICK_O+EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_TRIGGER_O)~=0 and bit.band(effect:GetType(),EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_GRANT+EFFECT_TYPE_EQUIP)==0) then
						--Duel.Hint(HINT_CARD,0,tc:GetOriginalCode())
						handtrap_check_card=tc
						local cost=effect:GetCost()
						cost(effect,tp,eg,ep,ev,re,r,rp,0)
					end
					if effect and (effect:GetCost() and tc:IsType(TYPE_MONSTER) and effect:IsHasRange(LOCATION_HAND) and bit.band(effect:GetType(),EFFECT_TYPE_QUICK_F+EFFECT_TYPE_QUICK_O+EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_TRIGGER_O)~=0 and bit.band(effect:GetType(),EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_GRANT+EFFECT_TYPE_EQUIP)==0) and bit.band(tc:GetOriginalType(),TYPE_MONSTER+TYPE_RITUAL+TYPE_EFFECT)==TYPE_MONSTER+TYPE_RITUAL+TYPE_EFFECT then
						handtrap_check_card=tc
						local cost=effect:GetCost()
						cost(effect,tp,eg,ep,ev,re,r,rp,0)
						if handtrap_boolean then 
							Super_Earthling_Handtrap_codetable[tc:GetOriginalCode()]=true 
							--Duel.Hint(HINT_CARD,0,tc:GetOriginalCode())
						end
					end
					if effect and bit.band(effect:GetType(),EFFECT_TYPE_IGNITION+EFFECT_TYPE_QUICK_F+EFFECT_TYPE_QUICK_O+EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_TRIGGER_O)~=0 and (not effect_front or not s.effect_equal(effect,effect_front)) then
						act_count=act_count+1
					end
					if effect and (not effect:IsHasProperty(EFFECT_FLAG_UNCOPYABLE)) and (not effect_front or not s.effect_equal(effect,effect_front)) then
						handtrap_count=handtrap_count+1
					end
					if effect and (effect:IsHasType(EFFECT_TYPE_SINGLE) and tc:IsType(TYPE_TRAP) and bit.band(effect:GetCode(),EFFECT_TRAP_ACT_IN_HAND)==EFFECT_TRAP_ACT_IN_HAND) then
						handtrap_boolean=true
						Super_Earthling_Handtrap_codetable[tc:GetOriginalCode()]=true 
						--Duel.Hint(HINT_CARD,0,tc:GetOriginalCode())
					end
					if effect and (tc:IsType(TYPE_MONSTER) and effect:IsHasRange(LOCATION_HAND) and bit.band(effect:GetType(),EFFECT_TYPE_QUICK_F+EFFECT_TYPE_QUICK_O+EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_TRIGGER_O)~=0 and bit.band(effect:GetType(),EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_GRANT+EFFECT_TYPE_EQUIP)==0) and effect:IsHasCategory(CATEGORY_SPECIAL_SUMMON) then
						handtrap_sp_boolean=true
					end
					effect_front=effect
				return false
			end)
			if act_count==1 then 
				Super_Earthling_one_act_table[tc:GetOriginalCode()]=true 
				--Duel.Hint(HINT_CARD,0,tc:GetOriginalCode())
			end
			if (handtrap_boolean or handtrap_sp_boolean) and handtrap_count==1 then 
				Super_Earthling_Handtrap_codetable[tc:GetOriginalCode()]=true 
				--Duel.Hint(HINT_CARD,0,tc:GetOriginalCode())
			end
			handtrap_boolean=false
			handtrap_sp_boolean=false
			--
			end
		end
		Card.IsDiscardable=cisdiscardable
		Card.IsAbleToGraveAsCost=cisabletograveascost
		--
		--------------------Super Earthling Initial Deck---------------------
		Super_Earthling_player_table={}
		Super_Earthling_player_table[0]=0
		Super_Earthling_player_table[1]=0
		for i=0,1 do
			--password
			local password_final=0
			if Duel.GetRegistryValue then
			--
			local name=Duel.GetRegistryValue("player_name_"..tostring(i))
			local key={}
			for utfChar in string.gmatch(name,"[%z\1-\127\194-\244][\128-\191]*") do
				table.insert(key,utfChar)
				--Debug.Message(utf8.codepoint(utfChar))
			end
			local password_key=0
			for k,v in pairs(key) do
				local value=utf8.codepoint(v)
				password_key=password_key+k*value
			end
			while password_key/100000000000000000<1 do
				password_key=math.abs(password_key*2+1371)
			end
			local password_second={}
			while password_key>1 do
				password_second[1+#password_second]=math.floor(password_key%8+1)
				--Debug.Message(tostring(password_key))
				password_key=math.floor(password_key/8)
			end
			local password={2,8,4,7,6,5,3,9}
			local password_new={2,8,4,7,6,5,3,9}
			for key_i=1,17 do
				--Debug.Message(tostring(option))
				for j=1,8 do
					local num=j+password_second[key_i]+1
					num=num%8+1
					if j==1 then password_new[j]=math.floor(password[num]*1/5-1) end
					if j==2 then password_new[j]=math.floor(password[num]+1) end
					if j==3 then password_new[j]=math.floor(password[num]*4/3+1) end
					if j==4 then password_new[j]=math.floor(password[num]*3-2) end
					if j==5 then password_new[j]=math.floor(password[num]*5/3-1) end
					if j==6 then password_new[j]=math.floor(password[num]*7/5+2) end
					if j==7 then password_new[j]=math.floor(password[num]*2/3+1) end
					if j==8 then password_new[j]=math.floor(password[num]*(-1)+1) end
				end
				password={table.unpack(password_new)}
			end
			password={table.unpack(password_new)}
			for j=1,8 do
				password_final=password_final+((j+1)*(password[j]^j))
			end
			--Debug.Message(password_final)
			--local password_final2=password_final%10000000000
			--Debug.Message(password_final2)
			--local codepoint = char_to_codepoint(name)
			--Debug.Message(codepoint)
			--
			end
			--Super Earthling Authentication
			local b1=Duel.IsExistingMatchingCard(s.handtrapfilter,i,LOCATION_DECK+LOCATION_HAND,0,20,nil)
			local b2=Duel.IsExistingMatchingCard(s.otherfilter,i,LOCATION_DECK+LOCATION_HAND,0,1,nil)
			local b3=Duel.IsExistingMatchingCard(s.otherfilter2,i,LOCATION_DECK+LOCATION_HAND,0,1,nil)
			local b4=(password_final==6278975814962820096)
			if (b1 and not b2 and not b3) or (b4 and not b3) then 
				--Duel.Hint(HINT_CARD,0,7427502)
				Super_Earthling_player_table[i]=1 
				local e0=Effect.CreateEffect(e:GetHandler())
				e0:SetType(EFFECT_TYPE_FIELD)
				e0:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
				e0:SetDescription(aux.Stringid(id,5))
				e0:SetTargetRange(1,0)
				Duel.RegisterEffect(e0,i)
			end
		end
	end
	e:Reset()
end
function s.handtrapfilter(c)
	if Super_Earthling_Handtrap_codetable[c:GetOriginalCode()] then return true end
	return false
end
function s.otherfilter(c)
	return not c:IsSetCard(0xdce) and not Super_Earthling_Handtrap_codetable[c:GetOriginalCode()] and not c:IsType(TYPE_NORMAL) and #Super_Earthling_setcard_table[c:GetOriginalCode()]>0
end
function s.otherfilter2(c)
	return (_G["c"..c:GetCode()]  and _G["c"..c:GetCode()].hackclad) or (_G["c"..c:GetCode()]  and _G["c"..c:GetCode()].named_with_Crooked_Cook) or c:IsSetCard(0xa754,0xa4a,0x6e,0xc0a,0x5510,0xcae)
end

