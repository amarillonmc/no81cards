--梦幻叙象「九月的雨」
function c10200128.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	-- ①：场地区域的表侧表示的这张卡不受其他卡的效果影响。这个效果不会被无效化。
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetRange(LOCATION_FZONE)
	e1:SetValue(c10200128.immval)
	c:RegisterEffect(e1)
	-- ②：自己·对方的准备阶段发动。属性宣言与记录。
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(1,10200128)
	e2:SetOperation(c10200128.sbop)
	c:RegisterEffect(e2)
end
-- 伪随机函数 (xorshift32)
c10200128._prng_state=0
function c10200128.prng(min,max)
	local x=c10200128._prng_state
	if x==0 then x=Duel.GetTurnCount()*7+Duel.GetTurnPlayer()*3+1 end
	x=x~(x<<13)
	x=x~(x>>17)
	x=x~(x<<5)
	c10200128._prng_state=x
	local r=x%2147483648
	if min and max then
		return min+(r%(max-min+1))
	elseif min then
		return (r%min)+1
	end
	return r
end
-- 免疫判定
function c10200128.immval(e,te)
	return te:GetOwner()~=e:GetHandler()
end
-- 注册当前天气提示（玩家侧持续显示，回合结束消失）
function c10200128.reg_cur_weather(card,tp,str_id)
	local e=Effect.CreateEffect(card)
	e:SetDescription(aux.Stringid(10200128,str_id))
	e:SetType(EFFECT_TYPE_FIELD)
	e:SetCode(0x20000000+10200128)
	e:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	e:SetTargetRange(1,0)
	e:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e,tp)
end
-- 清除所有记录
function c10200128.clear_all_records(c)
	if c:GetFlagEffect(10200128)>0 then
		c:SetFlagEffectLabel(10200128,0)
	end
	local codes={10200133,10200134,10200135,10200136,10200137,10200138,10200140,10200141}
	for _,fc in ipairs(codes) do
		c:ResetFlagEffect(fc)
	end
end
-- 准备阶段属性轮转
function c10200128.sbop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	-- 上回合适用了神属性，本回合适用彩虹
	if c:GetFlagEffect(10200129)>0 then
		c:ResetFlagEffect(10200129)
		c10200128.clear_all_records(c)
		c10200128.apply_rainbow_full(c,tp)
		c:RegisterFlagEffect(10200141,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(10200128,15))
		c10200128.reg_cur_weather(c,tp,7)
		return
	end
	local recorded=c:GetFlagEffectLabel(10200128)
	if not recorded then recorded=0 end
	-- 记录数为6，适用神属性
	if bit.band(recorded,0x3F)==0x3F then
		c10200128.apply_devine(c,tp)
		c:RegisterFlagEffect(10200129,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
		c:RegisterFlagEffect(10200140,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(10200128,14))
		c10200128.reg_cur_weather(c,tp,6)
		return
	end
	-- 双方宣言属性（神属性以外）
	Duel.Hint(HINT_SELECTMSG,0,HINTMSG_ATTRIBUTE)
	local a1=Duel.AnnounceAttribute(0,1,0x3F)
	Duel.Hint(HINT_SELECTMSG,1,HINTMSG_ATTRIBUTE)
	local a2=Duel.AnnounceAttribute(1,1,0x3F)
	local excl=a1|a2
	local avail=bit.band(0x3F,bit.bnot(excl))
	-- 从未被宣言的属性中伪随机选一个（神属性始终可被随机到）
	local attlist={}
	if bit.band(avail,ATTRIBUTE_LIGHT)~=0 then table.insert(attlist,ATTRIBUTE_LIGHT) end
	if bit.band(avail,ATTRIBUTE_DARK)~=0 then table.insert(attlist,ATTRIBUTE_DARK) end
	if bit.band(avail,ATTRIBUTE_WATER)~=0 then table.insert(attlist,ATTRIBUTE_WATER) end
	if bit.band(avail,ATTRIBUTE_FIRE)~=0 then table.insert(attlist,ATTRIBUTE_FIRE) end
	if bit.band(avail,ATTRIBUTE_EARTH)~=0 then table.insert(attlist,ATTRIBUTE_EARTH) end
	if bit.band(avail,ATTRIBUTE_WIND)~=0 then table.insert(attlist,ATTRIBUTE_WIND) end
	table.insert(attlist,ATTRIBUTE_DIVINE)
	if #attlist==0 then return end
	local pick=attlist[c10200128.prng(1,#attlist)]
	-- 记录基础属性
	if pick~=ATTRIBUTE_DIVINE then
		recorded=recorded|pick
		if c:GetFlagEffect(10200128)==0 then
			c:RegisterFlagEffect(10200128,RESET_EVENT+RESETS_STANDARD,0,1,recorded)
		else
			c:SetFlagEffectLabel(10200128,recorded)
		end
	end
	Duel.Hint(HINT_CARD,0,10200128)
	-- 显示天气提示
	c10200128.show_weather_hints(c,pick,recorded)
	-- 适用效果
	if pick==ATTRIBUTE_LIGHT then
		c10200128.apply_light(c,tp)
	elseif pick==ATTRIBUTE_DARK then
		c10200128.apply_dark(c,tp)
	elseif pick==ATTRIBUTE_WATER then
		c10200128.apply_water(c,tp)
	elseif pick==ATTRIBUTE_FIRE then
		c10200128.apply_fire(c,tp)
	elseif pick==ATTRIBUTE_EARTH then
		c10200128.apply_earth(c,tp)
	elseif pick==ATTRIBUTE_WIND then
		c10200128.apply_wind(c,tp)
	elseif pick==ATTRIBUTE_DIVINE then
		c10200128.apply_devine(c,tp)
		c:RegisterFlagEffect(10200129,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
		c:RegisterFlagEffect(10200140,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(10200128,14))
	end
end
-- 天气提示显示
function c10200128.show_weather_hints(c,att,recorded)
	-- 当前天气: 0=晴空 1=浓雾 2=暴雨 3=雷暴 4=沙暴 5=狂风 6=九月雨
	local cur_str=-1
	if att==ATTRIBUTE_LIGHT then cur_str=0
	elseif att==ATTRIBUTE_DARK then cur_str=1
	elseif att==ATTRIBUTE_WATER then cur_str=2
	elseif att==ATTRIBUTE_FIRE then cur_str=3
	elseif att==ATTRIBUTE_EARTH then cur_str=4
	elseif att==ATTRIBUTE_WIND then cur_str=5
	elseif att==ATTRIBUTE_DIVINE then cur_str=6
	end
	if cur_str>=0 then
		c10200128.reg_cur_weather(c,c:GetControler(),cur_str)
	end
	-- 记录提示: 8=晴空 9=浓雾 10=暴雨 11=雷暴 12=沙暴 13=狂风
	local rec_map={
		{ATTRIBUTE_LIGHT,10200133,8},
		{ATTRIBUTE_DARK,10200134,9},
		{ATTRIBUTE_WATER,10200135,10},
		{ATTRIBUTE_FIRE,10200136,11},
		{ATTRIBUTE_EARTH,10200137,12},
		{ATTRIBUTE_WIND,10200138,13},
	}
	for _,v in ipairs(rec_map) do
		local bit_val,flag_code,str_id=v[1],v[2],v[3]
		if bit.band(recorded,bit_val)~=0 and c:GetFlagEffect(flag_code)==0 then
			c:RegisterFlagEffect(flag_code,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(10200128,str_id))
		end
	end
end
-- 光{晴空}
function c10200128.apply_light(c,tp)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_MSET)
	e1:SetTargetRange(1,1)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_SSET)
	e2:SetTargetRange(1,1)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EFFECT_CANNOT_TURN_SET)
	e3:SetTargetRange(1,1)
	e3:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e3,tp)
	local g=Duel.GetMatchingGroup(Card.IsFacedown,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if g:GetCount()>0 then
		Duel.ChangePosition(g,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK,POS_FACEUP_DEFENSE,POS_FACEUP_DEFENSE)
	end
end
-- 暗{浓雾}
function c10200128.apply_dark(c,tp)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e1:SetRange(LOCATION_FZONE)
	e1:SetTargetRange(LOCATION_ONFIELD,0)
	e1:SetValue(aux.tgoval)
	e1:SetReset(RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(0,LOCATION_ONFIELD)
	e2:SetValue(c10200128.tgfilter)
	e2:SetReset(RESET_PHASE+PHASE_END)
	c:RegisterEffect(e2)
end
function c10200128.tgfilter(e,re,rp)
	return rp==e:GetHandlerPlayer()
end
-- 水{暴雨}
function c10200128.apply_water(c,tp)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_FZONE)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetValue(-1500)
	e1:SetReset(RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetValue(-1500)
	e2:SetReset(RESET_PHASE+PHASE_END)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
	e3:SetRange(LOCATION_FZONE)
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e3:SetReset(RESET_PHASE+PHASE_END)
	c:RegisterEffect(e3)
end
-- 炎{雷暴}
function c10200128.apply_fire(c,tp)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetRange(LOCATION_FZONE)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetOperation(c10200128.fireop)
	c:RegisterEffect(e1)
end
function c10200128.fireop(e,tp,eg,ep,ev,re,r,rp)
	for tc in aux.Next(eg) do
		local p=tc:GetSummonPlayer()
		local g=Duel.GetFieldGroup(p,LOCATION_ONFIELD,0)
		if g:GetCount()>0 then
			local list={}
			for fc in aux.Next(g) do table.insert(list,fc) end
			table.sort(list,function(a,b) return a:GetCode()<b:GetCode() end)
			local idx=c10200128.prng(1,#list)
			Duel.Destroy(list[idx],REASON_EFFECT)
		end
	end
end
-- 地{沙暴}
function c10200128.apply_earth(c,tp)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetRange(LOCATION_FZONE)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetOperation(c10200128.earthop)
	c:RegisterEffect(e1)
end
function c10200128.earthop(e,tp,eg,ep,ev,re,r,rp)
	local turnp=Duel.GetTurnPlayer()
	local ct=Duel.GetFieldGroupCount(turnp,LOCATION_ONFIELD,0)
	if ct>0 then
		Duel.Damage(turnp,ct*500,REASON_EFFECT)
	end
end
-- 风{狂风}
function c10200128.apply_wind(c,tp)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_DIRECT_ATTACK)
	e1:SetRange(LOCATION_FZONE)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetReset(RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetTargetRange(1,1)
	e2:SetReset(RESET_PHASE+PHASE_END)
	e2:SetValue(c10200128.coinfilter)
	Duel.RegisterEffect(e2,tp)
end
function c10200128.coinfilter(e,re,tp)
	return (re:IsHasCategory(CATEGORY_COIN) or re:IsHasCategory(CATEGORY_DICE))
end
-- 神{九月雨}
function c10200128.apply_devine(c,tp)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_ADJUST)
	e1:SetRange(LOCATION_FZONE)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetOperation(c10200128.devcheck)
	c:RegisterEffect(e1)
	c:RegisterFlagEffect(10200131,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1,Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD,LOCATION_ONFIELD))
end
function c10200128.devcheck(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local prev=c:GetFlagEffectLabel(10200131)
	if not prev then return end
	local cur=Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD,LOCATION_ONFIELD)
	if cur==prev then return end
	c:SetFlagEffectLabel(10200131,cur)
	c10200128.devrandom(e,tp)
end
function c10200128.devrandom(e,tp)
	local g=Duel.GetFieldGroup(tp,LOCATION_ONFIELD,LOCATION_ONFIELD)
	local battle_list={}
	local normal_list={}
	for tc in aux.Next(g) do
		local idx=c10200128.prng(1,7)
		if idx==6 then
			if not tc:IsHasEffect(EFFECT_INDESTRUCTABLE_BATTLE) and tc:IsDestructable() then
				table.insert(battle_list,tc)
			end
		elseif idx==1 then
			if tc:IsDestructable() then table.insert(normal_list,{tc,1}) end
		elseif idx==2 then
			if tc:IsAbleToGrave() then table.insert(normal_list,{tc,2}) end
		elseif idx==3 then
			if tc:IsAbleToRemove() then table.insert(normal_list,{tc,3}) end
		elseif idx==4 then
			if tc:IsAbleToHand() then table.insert(normal_list,{tc,4}) end
		elseif idx==5 then
			if tc:IsAbleToDeck() then table.insert(normal_list,{tc,5}) end
		elseif idx==7 then
			if tc:IsReleasableByEffect() then table.insert(normal_list,{tc,7}) end
		end
	end
	for _,v in ipairs(normal_list) do
		local tc,op=v[1],v[2]
		if op==1 then Duel.Destroy(tc,REASON_EFFECT)
		elseif op==2 then Duel.SendtoGrave(tc,REASON_EFFECT)
		elseif op==3 then Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
		elseif op==4 then Duel.SendtoHand(tc,nil,REASON_EFFECT)
		elseif op==5 then Duel.SendtoDeck(tc,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
		elseif op==7 then Duel.Release(tc,REASON_EFFECT)
		end
	end
	if #battle_list>0 then
		local bg=Group.CreateGroup()
		for _,tc in ipairs(battle_list) do bg:AddCard(tc) end
		Duel.Destroy(bg,REASON_BATTLE)
		local desg=Duel.GetOperatedGroup()
		if desg and #desg>0 then
			Duel.RaiseEvent(desg,EVENT_DESTROYED,e,REASON_BATTLE,tp,tp,Duel.GetCurrentChain())
			Duel.RaiseEvent(desg,EVENT_BATTLE_DESTROYED,e,REASON_BATTLE,tp,tp,Duel.GetCurrentChain())
			local dc=desg:GetFirst()
			while dc do
				Duel.RaiseSingleEvent(dc,EVENT_DESTROYED,e,REASON_BATTLE,tp,tp,Duel.GetCurrentChain())
				Duel.RaiseSingleEvent(dc,EVENT_BATTLE_DESTROYED,e,REASON_BATTLE,tp,tp,Duel.GetCurrentChain())
				dc=desg:GetNext()
			end
		end
	end
end
-- {彩虹}
function c10200128.apply_rainbow_full(c,tp)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetRange(LOCATION_FZONE)
	e1:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetValue(c10200128.rainbow_imm)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SET_ATTACK_FINAL)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetReset(RESET_PHASE+PHASE_END)
	e2:SetValue(c10200128.doubleatk)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_EXTRA_ATTACK)
	e3:SetRange(LOCATION_FZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetReset(RESET_PHASE+PHASE_END)
	e3:SetValue(7)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetRange(LOCATION_FZONE)
	e4:SetReset(RESET_PHASE+PHASE_END)
	e4:SetCountLimit(1,10200128+100)
	e4:SetOperation(c10200128.lpop)
	c:RegisterEffect(e4)
end
function c10200128.rainbow_imm(e,te)
	return te:GetOwner()~=e:GetHandler()
end
function c10200128.doubleatk(e,c)
	return c:GetBaseAttack()*2
end
function c10200128.lpop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SetLP(0,8000)
	Duel.SetLP(1,8000)
end
