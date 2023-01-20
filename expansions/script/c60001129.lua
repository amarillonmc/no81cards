--绝对之橙
local m=60001129
local cm=_G["c"..m]
Color_Song=Color_Song or {}
--注册---------------------------------------------------------
function Color_Song.MonsterRecord(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetOperation(Color_Song.Record_Op)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EVENT_FLIP)
	c:RegisterEffect(e3)
	return e1,e2,e3
end
function Color_Song.Record_Op(e,tp,eg,ep,ev,re,r,rp)
	local code=e:GetHandler():GetOriginalCode()
	local c=e:GetHandler()
	if not Duel.IsPlayerAffectedByEffect(tp,code) then
		Duel.RegisterFlagEffect(tp,code,0,0,1)
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(code,0))
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
		e1:SetCode(code)
		e1:SetTargetRange(1,0)
		Duel.RegisterEffect(e1,tp)
	end
end
--次数增加---------------------------------------------------------
function Color_Song.AddCount(c)
	if not Color_Song.AddCount_check then
		Color_Song.AddCount_check=true
		extraCount = {4,4}
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e1:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		e1:SetCountLimit(1)
		e1:SetOperation(Color_Song.AddCount_Op)
		Duel.RegisterEffect(e1,0)
		return e1
	end
end
function Color_Song.AddCount_Op(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,m-1)>=4 then Color_Song.AddC(tp) end
	if Duel.GetFlagEffect(1-tp,m-1)>=4 then Color_Song.AddC(1-tp) end
	Duel.ResetFlagEffect(tp,m-1)
	Duel.ResetFlagEffect(1-tp,m-1)
end
function Color_Song.AddC(tp)
	if not Color_Song.AddCount_check then return end
	extraCount[1+tp]=extraCount[1+tp]+1
end
--适用---------------------------------------------------------
function Color_Song.UseEffect(e,tp)
	local Orange=Duel.GetFlagEffect(tp,m)==1 and Duel.GetFlagEffect(1-tp,m)~=2 and Duel.IsExistingMatchingCard(aux.NecroValleyFilter(Card.IsAbleToHand),tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil)
	local Green =Duel.GetFlagEffect(tp,m+1)==1 and Duel.GetFlagEffect(1-tp,m+1)~=2 and Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
	local Black =Duel.GetFlagEffect(tp,m+2)==1 and Duel.GetFlagEffect(1-tp,m+2)~=2 and Duel.IsExistingMatchingCard(Color_Song.BlackFilter,tp,LOCATION_DECK,0,1,nil,tp)
	local Burn  =Duel.GetFlagEffect(tp,m+3)==1 and Duel.GetFlagEffect(1-tp,m+3)~=2 and Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,0,LOCATION_SZONE,1,nil)
	local Purple=Duel.GetFlagEffect(tp,m+4)==1 and Duel.GetFlagEffect(1-tp,m+4)~=2
	local Chaos =Duel.GetFlagEffect(tp,m+5)==1 and Duel.GetFlagEffect(1-tp,m+5)~=2 and Duel.IsExistingMatchingCard(Color_Song.ChaosFilter,tp,LOCATION_HAND,0,1,nil)
	local Pink  =Duel.GetFlagEffect(tp,m+6)==1 and Duel.GetFlagEffect(1-tp,m+6)~=2 and Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,0,1,nil)
	local Blue  =Duel.GetFlagEffect(tp,m+7)==1 and Duel.GetFlagEffect(1-tp,m+7)~=2
	local Yellow=Duel.GetFlagEffect(tp,m+8)==1 and Duel.GetFlagEffect(1-tp,m+8)~=2
	local White =Duel.GetFlagEffect(tp,m+9)==1 and Duel.GetFlagEffect(1-tp,m+9)~=2 and Duel.IsPlayerCanDraw(tp,1)
	local Memory=Duel.GetFlagEffect(tp,m+10)==1 and Duel.GetFlagEffect(1-tp,m+10)~=2 and Duel.IsExistingMatchingCard(Card.IsControlerCanBeChanged,tp,0,LOCATION_MZONE,1,nil)
	local Gray  =Duel.GetFlagEffect(tp,m+11)==1 and Duel.GetFlagEffect(1-tp,m+11)~=2 and Duel.IsExistingMatchingCard(Color_Song.GrayFilter,tp,LOCATION_DECK,0,1,nil)
	local Red   =Duel.GetFlagEffect(tp,m+12)==1 and Duel.GetFlagEffect(1-tp,m+12)~=2
	local Light =Duel.GetFlagEffect(tp,m+13)==1 and Duel.GetFlagEffect(1-tp,m+13)~=2 and Duel.IsExistingMatchingCard(aux.NecroValleyFilter(Color_Song.LightFilter),tp,LOCATION_GRAVE,0,1,nil,e,tp)
	local Hunter=Duel.GetFlagEffect(tp,m+14)==1 and Duel.GetFlagEffect(1-tp,m+14)~=2
	if not (Orange or green or Black or Burn or Purple or Chaos or Pink or Blue or Yellow or White or Memory or Gray or Red or Light or Hunter) then return end
	if Duel.GetFlagEffect(tp,m-1)>=extraCount[1+tp] then return end
	if Duel.SelectYesNo(tp,aux.Stringid(m,15)) then
		local off=1
		local ops={}
		local opval={}
		if Orange then
			ops[off]=aux.Stringid(m,0)
			opval[off-1]=1
			off=off+1
		end
		if Green then
			ops[off]=aux.Stringid(m+1,0)
			opval[off-1]=2
			off=off+1
		end
		if Black then
			ops[off]=aux.Stringid(m+2,0)
			opval[off-1]=3
			off=off+1
		end
		if Burn then
			ops[off]=aux.Stringid(m+3,0)
			opval[off-1]=4
			off=off+1
		end
		if Purple then
			ops[off]=aux.Stringid(m+4,0)
			opval[off-1]=5
			off=off+1
		end
		if Chaos then
			ops[off]=aux.Stringid(m+5,0)
			opval[off-1]=6
			off=off+1
		end
		if Pink then
			ops[off]=aux.Stringid(m+6,0)
			opval[off-1]=7
			off=off+1
		end
		if Blue then
			ops[off]=aux.Stringid(m+7,0)
			opval[off-1]=8
			off=off+1
		end
		if Yellow then
			ops[off]=aux.Stringid(m+8,0)
			opval[off-1]=9
			off=off+1
		end
		if White then
			ops[off]=aux.Stringid(m+9,0)
			opval[off-1]=10
			off=off+1
		end
		if Memory then
			ops[off]=aux.Stringid(m+10,0)
			opval[off-1]=11
			off=off+1
		end
		if Gray then
			ops[off]=aux.Stringid(m+11,0)
			opval[off-1]=12
			off=off+1
		end
		if Red then
			ops[off]=aux.Stringid(m+12,0)
			opval[off-1]=13
			off=off+1
		end
		if Light then
			ops[off]=aux.Stringid(m+13,0)
			opval[off-1]=14
			off=off+1
		end
		if Hunter then
			ops[off]=aux.Stringid(m+14,0)
			opval[off-1]=15
			off=off+1
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EFFECT)
		local op=Duel.SelectOption(tp,table.unpack(ops))
		if opval[op]==1 then
			Color_Song.Orange_Op(e,tp)
		elseif opval[op]==2 then
			Color_Song.Green_Op(e,tp)
		elseif opval[op]==3 then
			Color_Song.Black_Op(e,tp)
		elseif opval[op]==4 then
			Color_Song.Burn_Op(e,tp)
		elseif opval[op]==5 then
			Color_Song.Purple_Op(e,tp)
		elseif opval[op]==6 then
			Color_Song.Chaos_Op(e,tp)
		elseif opval[op]==7 then
			Color_Song.Pink_Op(e,tp)
		elseif opval[op]==8 then
			Color_Song.Blue_Op(e,tp)
		elseif opval[op]==9 then
			Color_Song.Yellow_Op(e,tp)
		elseif opval[op]==10 then
			Color_Song.White_Op(e,tp)
		elseif opval[op]==11 then
			Color_Song.Memory_Op(e,tp)
		elseif opval[op]==12 then
			Color_Song.Gray_Op(e,tp)
		elseif opval[op]==13 then
			Color_Song.Red_Op(e,tp)
		elseif opval[op]==14 then
			Color_Song.Light_Op(e,tp)
		elseif opval[op]==15 then
			Color_Song.Hunter_Op(e,tp)
		end
		Duel.RegisterFlagEffect(tp,m+opval[op]-1,RESET_PHASE+PHASE_END,0,1)
		Duel.RegisterFlagEffect(tp,m-1,RESET_PHASE+PHASE_DRAW,0,1)
	end
end
--Orange
function Color_Song.Orange__Limit(e,re,tp)
	return re:GetHandler():IsCode(e:GetLabel())
end
function Color_Song.Orange_Op(e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(Card.IsAbleToHand),tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil):GetFirst()
	if tc then
		Duel.SendtoHand(tc,tp,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_ACTIVATE)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(1,0)
		e1:SetValue(Color_Song.Orange__Limit)
		e1:SetLabel(tc:GetCode())
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
end
--Green
function Color_Song.Green_Op(e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tc=Duel.SelectMatchingCard(tp,Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	if tc then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
--Black
function Color_Song.BlackFilter(c,tp)
	return c.isColorSong and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable() and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
end
function Color_Song.Black_Op(e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local tc=Duel.SelectMatchingCard(tp,Color_Song.BlackFilter,tp,LOCATION_DECK,0,1,1,nil,tp)
	if tc then
		Duel.SSet(tp,tc)
		Duel.ConfirmCards(1-tp,tc)
	end
end
--Burn
function Color_Song.Burn_Op(e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local tc=Duel.SelectMatchingCard(tp,Card.IsAbleToGrave,tp,0,LOCATION_SZONE,1,1,nil)
	if tc then
		Duel.SendtoGrave(tc,REASON_EFFECT)
	end
end
--Purple
function Color_Song.Purple_Op(e,tp)
	Duel.Recover(tp,1500,REASON_EFFECT)
end
--Chaos
function Color_Song.ChaosFilter(c)
	return c.isColorSong and c:IsSummonable(true,nil) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end
function Color_Song.Chaos_Op(e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local tc=Duel.SelectMatchingCard(tp,Color_Song.ChaosFilter,tp,LOCATION_HAND,0,1,1,nil):GetFirst()
	if tc then
		Duel.Summon(tp,tc,true,nil)
	end
end
--Pink
function Color_Song.Pink_Op(e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local tc=Duel.SelectMatchingCard(tp,nil,tp,0,LOCATION_MZONE,1,1,nil):GetFirst()
	if tc then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e1:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetValue(1)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
		tc:RegisterEffect(e2)
		local e3=e1:Clone()
		e3:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
		tc:RegisterEffect(e3)
		local e4=e1:Clone()
		e4:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
		tc:RegisterEffect(e4)
	end
end
--Blue
function Color_Song.Blue_tgfil(c,tp)
	return c:IsControler(tp) and c:IsOnField()
end
function Color_Song.Blue_negcon(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return rp==1-tp and g:IsExists(Color_Song.Blue_tgfil,1,nil,tp) and Duel.IsChainNegatable(ev) and Duel.GetFlagEffect(tp,m-2)==0
end
function Color_Song.Blue_negop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.SelectYesNo(tp,aux.Stringid(m-2,1)) then
		Duel.Hint(HINT_CARD,0,m+7)
		Duel.NegateEffect(ev)
		Duel.RegisterFlagEffect(tp,m-2,RESET_PHASE+PHASE_END,0,1)
	end
end
function Color_Song.Blue_Op(e,tp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_SOLVING)
	e1:SetCondition(Color_Song.Blue_negcon)
	e1:SetOperation(Color_Song.Blue_negop)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
--Yellow
function Color_Song.Yellow_Target(c)
	return c.isColorSong
end
function Color_Song.Yellow_Op(e,tp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(aux.TargetBoolFunction(Color_Song.Yellow_Target))
	e1:SetValue(1)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
--White
function Color_Song.White_Op(e,tp)
	Duel.Draw(tp,1,REASON_EFFECT)
end
--Memory
function Color_Song.Memory_Op(e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local tc=Duel.SelectMatchingCard(tp,Card.IsControlerCanBeChanged,tp,0,LOCATION_MZONE,1,1,nil):GetFirst()
	if tc then
		Duel.GetControl(tc,tp,PHASE_END,2)
	end
end
--Gray
function Color_Song.GrayFilter(c,e,tp)
	return c.isColorSong and c:IsAbleToGrave()
end
function Color_Song.Gray_Op(e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local tc=Duel.SelectMatchingCard(tp,Color_Song.GrayFilter,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
	if tc then
		Duel.SendtoGrave(tc,REASON_EFFECT)
	end
end
--Red
function Color_Song.Red_Op(e,tp)
	Duel.Damage(1-tp,600,REASON_EFFECT)
end
--Light
function Color_Song.LightFilter(c,e,tp)
	return c.isColorSong and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end
function Color_Song.Light_Op(e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local tc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(Color_Song.LightFilter),tp,LOCATION_GRAVE,0,1,1,nil,e,tp):GetFirst()
	if tc then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
--Hunter
function Color_Song.Hunter_Filter(c,att,rac)
	return c:IsFaceup() and (c:IsAttribute(att) or c:IsRace(rac))
end
function Color_Song.Hunter_drFilter(c,tp)
	return not Duel.IsExistingMatchingCard(Color_Song.Hunter_Filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,c,c:GetAttribute(),c:GetRace()) and c:IsSummonPlayer(tp)
end
function Color_Song.Hunter_drcon1(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Color_Song.Hunter_drFilter,1,nil,1-tp)
		and (not re:IsHasType(EFFECT_TYPE_ACTIONS) or re:IsHasType(EFFECT_TYPE_CONTINUOUS))
end
function Color_Song.Hunter_drop1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Draw(tp,1,REASON_EFFECT)
	Duel.Draw(1-tp,1,REASON_EFFECT)
end
function Color_Song.Hunter_regcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Color_Song.Hunter_drFilter,1,nil,1-tp)
		and re:IsHasType(EFFECT_TYPE_ACTIONS) and not re:IsHasType(EFFECT_TYPE_CONTINUOUS)
end
function Color_Song.Hunter_regop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(tp,m-3,RESET_CHAIN,0,1)
end
function Color_Song.Hunter_drcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,m-3)>0
end
function Color_Song.Hunter_drop2(e,tp,eg,ep,ev,re,r,rp)
	local n=Duel.GetFlagEffect(tp,m-3)
	Duel.ResetFlagEffect(tp,m-3)
	Duel.Draw(tp,n,REASON_EFFECT)
	Duel.Draw(1-tp,n,REASON_EFFECT)
end
function Color_Song.Hunter_Op(e,tp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(Color_Song.Hunter_drcon1)
	e1:SetOperation(Color_Song.Hunter_drop1)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	--sp_summon effect
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(Color_Song.Hunter_regcon)
	e2:SetOperation(Color_Song.Hunter_regop)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetCode(EVENT_CHAIN_SOLVED)
	e3:SetCondition(Color_Song.Hunter_drcon2)
	e3:SetOperation(Color_Song.Hunter_drop2)
	e3:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e3,tp)
end
--泛用函数---------------------------------------------------------
--这个回合，自己不是不死族怪兽不能特殊召唤。
function Color_Song.Zombie_Limit(e,tp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(Color_Song.Not_Zombie)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function Color_Song.Not_Zombie(e,c)
	return not c:IsRace(RACE_ZOMBIE)
end
------------------------------------------------------------------------------------------------------------------------------------------
if not cm then return end
cm.isColorSong=true  --乱色狂歌
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkRace,RACE_ZOMBIE),2,2)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.con1)
	e1:SetTarget(cm.tg1)
	e1:SetOperation(cm.op1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,m)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(cm.tg2)
	e2:SetOperation(cm.op2)
	c:RegisterEffect(e2)
	local record=Color_Song.MonsterRecord(c)
	Color_Song.AddCount(c)
end
--e1
function cm.con1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function cm.tgf1(c)
	return c.isColorSong and c:IsAbleToHand() and c:IsType(TYPE_MONSTER)
end
function cm.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.NecroValleyFilter(cm.tgf1),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.tgf1),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
	Color_Song.Zombie_Limit(e,tp)
	Color_Song.UseEffect(e,tp)
end
--e2
function cm.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.NecroValleyFilter(cm.tgf1),tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.tgf1),tp,LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
	Color_Song.UseEffect(e,tp)
end