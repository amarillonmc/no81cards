local m=15005334
local cm=_G["c"..m]
cm.name="『繁育』的荒潮-塔伊兹育罗斯"
function cm.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,3,3,nil,nil,99)
	c:EnableReviveLimit()
	--cannot disable spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCondition(cm.effcon)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(15005334)
	e2:SetRange(LOCATION_MZONE)
	c:RegisterEffect(e2)
	--destroy replace
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_DESTROY_REPLACE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTarget(cm.desreptg)
	e3:SetValue(cm.desrepval)
	e3:SetOperation(cm.desrepop)
	c:RegisterEffect(e3)
	--
	if not cm.TayzzyronthTDDCheck then
		cm.TayzzyronthTDDCheck=true
		--spsummon check
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD)
		e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e3:SetTargetRange(1,1)
		e3:SetTarget(cm.sumlimit)
		Duel.RegisterEffect(e3,0)
		--hack1
		TayzzyronthTDDSpecialSummon=Duel.SpecialSummon
		function Duel.SpecialSummon(sg,typ,sp,tp,nochk,nolim,pos,zone)
			if not zone then zone=0xff end
			local p=0
			local mchk=false
			if Duel.IsExistingMatchingCard(cm.Tayzzyronthfilter,0,0xff,0,1,nil) then
				p=0
				mchk=true
			end
			if Duel.IsExistingMatchingCard(cm.Tayzzyronthfilter,1,0xff,0,1,nil) then
				p=1
				mchk=true
			end
			if Duel.IsExistingMatchingCard(cm.Tayzzyronthfilter,0,0xff,0,1,nil) and Duel.IsExistingMatchingCard(cm.Tayzzyronthfilter,1,0xff,0,1,nil) then
				p=PLAYER_ALL
				mchk=true
			end
			local count=0
			local removechk=false
			local chk=false
			if aux.GetValueType(sg)=="Card" then
				count=1
				removechk=sg:IsAbleToRemove(p,POS_FACEDOWN,REASON_EFFECT+REASON_REPLACE)
				chk=cm.sumfilter(sg)
			end
			if aux.GetValueType(sg)=="Group" then
				count=#sg
				removechk=sg:IsExists(Card.IsAbleToRemove,#sg,nil,p,POS_FACEDOWN,REASON_EFFECT+REASON_REPLACE)
				chk=sg:IsExists(cm.sumfilter,#sg,nil)
			end
			if mchk and chk and removechk and Duel.IsPlayerCanSpecialSummonMonster(sp,15005335,nil,0x4011,0,0,1,RACE_INSECT,ATTRIBUTE_EARTH,POS_FACEUP,tp) and Duel.Remove(sg,POS_FACEDOWN,REASON_EFFECT+REASON_REPLACE) then
				local x=0
				sg=Group.CreateGroup()
				while x<count do
					local token=Duel.CreateToken(tp,15005335)
					TayzzyronthTDDSpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
					local ec=Duel.GetFirstMatchingCard(cm.Tayzzyronthfilter,0,LOCATION_MZONE,LOCATION_MZONE,nil)
					local e1=Effect.CreateEffect(ec)
					e1:SetType(EFFECT_TYPE_SINGLE)
					e1:SetCode(EFFECT_UNRELEASABLE_SUM)
					e1:SetValue(1)
					e1:SetReset(RESET_EVENT+RESETS_STANDARD)
					token:RegisterEffect(e1,true)
					local e2=e1:Clone()
					e2:SetCode(EFFECT_UNRELEASABLE_NONSUM)
					token:RegisterEffect(e2,true)
					local e3=e2:Clone()
					e3:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
					token:RegisterEffect(e3,true)
					local e4=e2:Clone()
					e4:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
					token:RegisterEffect(e4,true)
					local e5=e2:Clone()
					e5:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
					token:RegisterEffect(e5,true)
					x=x+1
				end
				Duel.SpecialSummonComplete()
			else
				local x=TayzzyronthTDDSpecialSummon(sg,typ,sp,tp,nochk,nolim,pos,zone)
			end
			return x
		end
		--hack2
		TayzzyronthTDDSpecialSummonStep=Duel.SpecialSummonStep
		function Duel.SpecialSummonStep(sg,typ,sp,tp,nochk,nolim,pos,zone)
			if not zone then zone=0xff end
			local p=0
			local mchk=false
			if Duel.IsExistingMatchingCard(cm.Tayzzyronthfilter,0,LOCATION_MZONE,0,1,nil) then
				p=0
				mchk=true
			end
			if Duel.IsExistingMatchingCard(cm.Tayzzyronthfilter,1,LOCATION_MZONE,0,1,nil) then
				p=1
				mchk=true
			end
			if Duel.IsExistingMatchingCard(cm.Tayzzyronthfilter,0,LOCATION_MZONE,0,1,nil) and Duel.IsExistingMatchingCard(cm.Tayzzyronthfilter,1,LOCATION_MZONE,0,1,nil) then
				p=PLAYER_ALL
				mchk=true
			end
			local count=0
			local removechk=false
			local chk=false
			if aux.GetValueType(sg)=="Card" then
				count=1
				removechk=sg:IsAbleToRemove(p,POS_FACEDOWN,REASON_EFFECT+REASON_REPLACE)
				chk=cm.sumfilter(sg)
			end
			if aux.GetValueType(sg)=="Group" then
				count=#sg
				removechk=sg:IsExists(Card.IsAbleToRemove,#sg,nil,p,POS_FACEDOWN,REASON_EFFECT+REASON_REPLACE)
				chk=sg:IsExists(cm.sumfilter,#sg,nil)
			end
			if mchk and chk and removechk and Duel.IsPlayerCanSpecialSummonMonster(sp,15005335,nil,0x4011,0,0,1,RACE_INSECT,ATTRIBUTE_EARTH,POS_FACEUP,tp) and Duel.Remove(sg,POS_FACEDOWN,REASON_EFFECT+REASON_REPLACE) then
				local x=0
				local res=false
				while x<count do
					local token=Duel.CreateToken(tp,15005335)
					res=TayzzyronthTDDSpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
					local ec=Duel.GetFirstMatchingCard(cm.Tayzzyronthfilter,0,LOCATION_MZONE,LOCATION_MZONE,nil)
					local e1=Effect.CreateEffect(ec)
					e1:SetType(EFFECT_TYPE_SINGLE)
					e1:SetCode(EFFECT_UNRELEASABLE_SUM)
					e1:SetValue(1)
					e1:SetReset(RESET_EVENT+RESETS_STANDARD)
					token:RegisterEffect(e1,true)
					local e2=e1:Clone()
					e2:SetCode(EFFECT_UNRELEASABLE_NONSUM)
					token:RegisterEffect(e2,true)
					local e3=e2:Clone()
					e3:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
					token:RegisterEffect(e3,true)
					local e4=e2:Clone()
					e4:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
					token:RegisterEffect(e4,true)
					local e5=e2:Clone()
					e5:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
					token:RegisterEffect(e5,true)
					x=x+1
				end
				Duel.SpecialSummonComplete()
			else
				local res=TayzzyronthTDDSpecialSummonStep(sg,typ,sp,tp,nochk,nolim,pos,zone)
			end
			return res
		end
	end
end
function cm.effcon(e)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function cm.Tayzzyronthfilter(c)
	return c:GetEffectCount(15005334)~=0 and c:IsFaceup()
end
function cm.sumfilter(c)
	return c:GetFlagEffect(15005334)~=0
end
function cm.sumlimit(e,c,sump,sumtype,sumpos,targetp,se)
	if se:IsActivated() and se:IsHasType(EFFECT_TYPE_ACTIONS) then
		c:RegisterFlagEffect(15005334,RESET_EVENT+RESETS_STANDARD+RESET_CHAIN,EFFECT_FLAG_SET_AVAILABLE,1)
	end
	return false
end
function cm.repfilter(c)
	return c:IsOnField() and c:IsFaceup() and c:IsRace(RACE_INSECT)
		and c:IsReason(REASON_BATTLE+REASON_EFFECT) and not c:IsReason(REASON_REPLACE)
end
function cm.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return eg:IsExists(cm.repfilter,1,nil)
		and c:CheckRemoveOverlayCard(tp,1,REASON_EFFECT) end
	return true
end
function cm.desrepval(e,c)
	return cm.repfilter(c)
end
function cm.desrepop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_EFFECT)
	Duel.Hint(HINT_CARD,0,15005334)
end