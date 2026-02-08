local s,id=GetID()
local t_unpack=table.unpack or unpack

function s.initial_effect(c)
	-- Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end

-- 魔陷区过滤器（排除场地区 sequence=5）
function s.szfilter(c)
	return c:GetSequence()<5
end

-- 对方在对应区域卡数是否多于自己
function s.get_zone_adv(tp)
	-- 手卡
	local opp_h=Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)
	local me_h =Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
	-- 怪兽区
	local opp_m=Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)
	local me_m =Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)
	-- 魔陷区（不含场地）
	local opp_s=Duel.GetMatchingGroupCount(s.szfilter,tp,0,LOCATION_SZONE,nil)
	local me_s =Duel.GetMatchingGroupCount(s.szfilter,tp,LOCATION_SZONE,0,nil)

	local bh=opp_h>me_h
	local bm=opp_m>me_m
	local bs=opp_s>me_s

	local ct=0
	if bh then ct=ct+1 end
	if bm then ct=ct+1 end
	if bs then ct=ct+1 end
	return ct,bh,bm,bs
end

function s.spfilter(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

function s.setfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable()
end

function s.canop1(tp)
	return Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)>0
end

function s.canop2(e,tp)
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(aux.NecroValleyFilter(s.spfilter),tp,0,LOCATION_GRAVE+LOCATION_REMOVED,1,nil,e,tp)
end

function s.canop3(tp)
	return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(aux.NecroValleyFilter(s.setfilter),tp,0,LOCATION_GRAVE+LOCATION_REMOVED,1,nil)
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct,bh,bm,bs=s.get_zone_adv(tp)
	if chk==0 then
		return ct>0 and (s.canop1(tp) or s.canop2(e,tp) or s.canop3(tp))
	end

	-- 对应发动限制（只限制对方）
	Duel.SetChainLimit(function(re2,rp2,tp2)
		if tp2==tp then return true end
		local hc=re2:GetHandler()
		if not hc then return true end
		local loc=hc:GetLocation()
		local seq=hc:GetSequence()
		if bh and loc==LOCATION_HAND then return false end
		if bm and loc==LOCATION_MZONE then return false end
		if bs and loc==LOCATION_SZONE and seq<5 then return false end
		return true
	end)
end

function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local ct=s.get_zone_adv(tp)
	if ct<=0 then return end

	for i=1,ct do
		local ops={}
		local map={}

		if s.canop1(tp) then
			ops[#ops+1]=aux.Stringid(id,0)
			map[#map+1]=1
		end
		if s.canop2(e,tp) then
			ops[#ops+1]=aux.Stringid(id,1)
			map[#map+1]=2
		end
		if s.canop3(tp) then
			ops[#ops+1]=aux.Stringid(id,2)
			map[#map+1]=3
		end

		if #ops==0 then return end
		local sel=map[Duel.SelectOption(tp,t_unpack(ops))+1]

		if sel==1 then
			-- 从对方卡组顶取1张加入自己手卡
			local g=Duel.GetDecktopGroup(1-tp,1)
			if #g>0 then
				Duel.DisableShuffleCheck()
				Duel.SendtoHand(g,tp,REASON_EFFECT)
			end

		elseif sel==2 then
			-- 对方墓地/除外怪兽特召到自己场上
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.spfilter),tp,0,LOCATION_GRAVE+LOCATION_REMOVED,1,1,nil,e,tp)
			local tc=g:GetFirst()
			if tc then
				Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
			end

		else -- sel==3
			-- 对方墓地/除外魔陷盖放到自己场上
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
			local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.setfilter),tp,0,LOCATION_GRAVE+LOCATION_REMOVED,1,1,nil)
			local tc=g:GetFirst()
			if tc and Duel.SSet(tp,tc)>0 then
				local c=e:GetHandler()
				if tc:IsType(TYPE_QUICKPLAY) then
					local e1=Effect.CreateEffect(c)
					e1:SetType(EFFECT_TYPE_SINGLE)
					e1:SetCode(EFFECT_QP_ACT_IN_SET_TURN)
					e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
					e1:SetReset(RESET_EVENT+RESETS_STANDARD)
					tc:RegisterEffect(e1)
				elseif tc:IsType(TYPE_TRAP) then
					local e2=Effect.CreateEffect(c)
					e2:SetType(EFFECT_TYPE_SINGLE)
					e2:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
					e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
					e2:SetReset(RESET_EVENT+RESETS_STANDARD)
					tc:RegisterEffect(e2)
				end
			end
		end
	end
end
