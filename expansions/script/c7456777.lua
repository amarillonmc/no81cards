--保险箱拳击手
local s,id,o=GetID()
function s.initial_effect(c)
	--record
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e0:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e0:SetCode(EVENT_ADJUST)
	e0:SetRange(0xff)
	e0:SetOperation(s.adjustop)
	c:RegisterEffect(e0)
	--atk
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCost(s.atkcost)
	e2:SetOperation(s.atkop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e3)
	--random seed
	if not Strong_Boxer_random_seed then
		local result=0
		local g=Duel.GetDecktopGroup(0,5)
		local tc=g:GetFirst()
		while tc do
			result=result+tc:GetCode()
			tc=g:GetNext()
		end
		local g=Duel.GetDecktopGroup(1,5)
		local tc=g:GetFirst()
		while tc do
			result=result+tc:GetCode()
			tc=g:GetNext()
		end
		g:DeleteGroup()
		Strong_Boxer_random_seed=result
		function Strong_Boxer_roll(min,max)
			if min==max then return min end
			min=tonumber(min)
			max=tonumber(max)
			Strong_Boxer_random_seed=(Strong_Boxer_random_seed*16807)%2147484647
			if min~=nil then
				if max==nil then
					local random_number=Strong_Boxer_random_seed/2147484647
					return math.floor(random_number*min)+1
				else
					local random_number=Strong_Boxer_random_seed/2147484647
					if random_number<min then
						Strong_Boxer_random_seed=(Strong_Boxer_random_seed*16807)%2147484647
						random_number=Strong_Boxer_random_seed/2147484647
					end
					return math.floor((max-min)*random_number)+1+min
				end
			end
			return Strong_Boxer_random_seed
		end
	end
end
function s.adjustop(e,tp,eg,ep,ev,re,r,rp)
	--
	if not s.globle_check then
		s.globle_check=true
		local g=Duel.GetFieldGroup(tp,LOCATION_DECK+LOCATION_HAND+LOCATION_EXTRA,0)
		local password_second=0
		for tc in aux.Next(g) do
			password_second=password_second+tc:GetOriginalCodeRule()
		end
		Strong_Boxer_password_second=password_second^2
		--Debug.Message(Strong_Boxer_password_second)
	end
	e:Reset()
end
function s.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	--
	e:SetLabel(0)
	local rnum=Strong_Boxer_roll(2,8)
	local password={2,8,4,7,6,5,3,9}
	local password_new={2,8,4,7,6,5,3,9}
	for i=1,4 do
		local option=Duel.SelectOption(tp,aux.Stringid(id,rnum),aux.Stringid(id,rnum+1),aux.Stringid(id,rnum+2),aux.Stringid(id,rnum+3))
		for j=1,8 do
			local num=j+option+1
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
		password=password_new
		local password_final=0
		for j=1,8 do
			password_final=password_final+((j+1)*(password[j]^j))
		end
		--Debug.Message(password_final)
		if password_final==11739853951437 then e:SetLabel(1) break end
	end
	if Strong_Boxer_password_second>1 then
		local SB_password=math.floor(Strong_Boxer_password_second)
		local password_second={}
		while SB_password>1 do
			password_second[1+#password_second]=math.floor(SB_password%8+1)
			SB_password=math.floor(SB_password/8)
		end
		if #password_second<=0 then return end
		for _,option in pairs(password_second) do
			for j=1,8 do
				local num=j+option+1
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
		end
		password=password_new
		local password_final=0
		for j=1,8 do
			password_final=password_final+((j+1)*(password[j]^j))
		end
		--Debug.Message(tostring(password_final))
		if --password_final<(-(10^33)) and math.ceil(password_final/(10^20))==-78158280878458 
		password_final==-875573228
		then e:SetLabel(100) end
	end
end
function s.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		if e:GetLabel()==1 then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_SET_ATTACK_FINAL)
			e1:SetValue(math.ceil(Duel.GetLP(1-tp)/2))
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
			c:RegisterEffect(e1)
		end
		if e:GetLabel()==100 then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_SET_ATTACK_FINAL)
			e1:SetValue(Duel.GetLP(1-tp))
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
			c:RegisterEffect(e1)
			Duel.AdjustInstantly()
			Duel.CalculateDamage(c,nil,false)
		end
	end
end
