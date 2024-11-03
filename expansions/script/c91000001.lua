--北极天熊-七政
local s,id,o=GetID()
function c91000001.initial_effect(c)
	--
	if c:GetOriginalCode()==id then

	--adjust
	local e01=Effect.CreateEffect(c)
	e01:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e01:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e01:SetCode(EVENT_ADJUST)
	e01:SetRange(0xff)
	e01:SetOperation(s.adjustop)
	c:RegisterEffect(e01)

	end
	
end
function s.filter(c)
	return not c:IsCode(id)
end
function s.actarget(e,te,tp)
	--prevent activating
	local tc=te:GetHandler()
	return (te:GetValue()==id and (not Duel.IsPlayerAffectedByEffect(te:GetHandlerPlayer(),id) or tc:GetFlagEffect(id)~=0))  
	--prevent normal activating beside S&T on field
	or (te:GetValue()==id+1 and Duel.IsPlayerAffectedByEffect(te:GetHandlerPlayer(),id) and not (te:IsHasType(EFFECT_TYPE_ACTIVATE) and tc:IsLocation(LOCATION_SZONE)) and not tc:IsLocation(LOCATION_DECK))
end
function s.NTR_Reform(effect)
				local eff=effect:Clone()
				local con=eff:GetCondition()
				local cost=eff:GetCost()
				local target=eff:GetTarget()
				local operation=eff:GetOperation()
				local pro=eff:GetProperty()
				if not eff:IsHasProperty(EFFECT_FLAG_BOTH_SIDE) and eff:IsHasType(EFFECT_TYPE_TRIGGER_O|EFFECT_TYPE_TRIGGER_F|EFFECT_TYPE_IGNITION|EFFECT_TYPE_QUICK_F|EFFECT_TYPE_QUICK_O|EFFECT_TYPE_FLIP) then
					eff:SetProperty(pro+EFFECT_FLAG_BOTH_SIDE)
					if con then
						eff:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
							if tp~=e:GetHandler():GetOwner() and not Duel.IsPlayerAffectedByEffect(tp,id) then return false end
							if tp~=e:GetHandler():GetOwner() and Duel.IsPlayerAffectedByEffect(tp,id) then return con(e,1-tp,eg,ep,ev,re,r,rp) end
							return con(e,tp,eg,ep,ev,re,r,rp)
						end)
					else
						eff:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
							if tp~=e:GetHandler():GetOwner() and not Duel.IsPlayerAffectedByEffect(tp,id) then return false end
							return true 
						end)
					end
					if cost then
						eff:SetCost(function(e,tp,eg,ep,ev,re,r,rp,chk)
							if tp~=e:GetHandler():GetOwner() and not Duel.IsPlayerAffectedByEffect(tp,id) then return false end
							if tp~=e:GetHandler():GetOwner() and Duel.IsPlayerAffectedByEffect(tp,id) then 
								if chk==0 then
									return cost(e,1-tp,eg,ep,ev,re,r,rp,0)
								end
								NTR_Effect_Blacklotus=true
								cost(e,1-tp,eg,ep,ev,re,r,rp,chk)
								NTR_Effect_Blacklotus=false
								return
							end
							if chk==0 then
								return cost(e,tp,eg,ep,ev,re,r,rp,0)
							end
							cost(e,tp,eg,ep,ev,re,r,rp,chk)
						end)
					end
					if target then
						eff:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
							if tp~=e:GetHandler():GetOwner() and not Duel.IsPlayerAffectedByEffect(tp,id) then return false end
							if tp~=e:GetHandler():GetOwner() and Duel.IsPlayerAffectedByEffect(tp,id) then 
								if chkc==0 then
									return target(e,1-tp,eg,ep,ev,re,r,rp,chk,0)
								end
								if chk==0 then
									return target(e,1-tp,eg,ep,ev,re,r,rp,0,chkc)
								end
								NTR_Effect_Blacklotus=true
								target(e,1-tp,eg,ep,ev,re,r,rp,chk,chkc)
								NTR_Effect_Blacklotus=false
								return
							end
							if chkc==0 then
								return target(e,tp,eg,ep,ev,re,r,rp,chk,0)
							end
							if chk==0 then
								return target(e,tp,eg,ep,ev,re,r,rp,0,chkc)
							end
							target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
						end)
					end
					if operation then
						eff:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
							if tp~=e:GetHandler():GetOwner() and not Duel.IsPlayerAffectedByEffect(tp,id) then return false end
							if tp~=e:GetHandler():GetOwner() and Duel.IsPlayerAffectedByEffect(tp,id) then 
								NTR_Effect_Blacklotus=true
								operation(e,1-tp,eg,ep,ev,re,r,rp)
								NTR_Effect_Blacklotus=false
								return
							end
							operation(e,tp,eg,ep,ev,re,r,rp)
						end)
					end
				end
	return eff
end
function s.NTR_Reform2(effect)
				local eff=effect:Clone()
				local con=eff:GetCondition()
				local cost=eff:GetCost()
				local target=eff:GetTarget()
				local operation=eff:GetOperation()
				local pro=eff:GetProperty()
				if eff:GetType()~=EFFECT_TYPE_FIELD and eff:GetType()~=EFFECT_TYPE_SINGLE then
					if cost then
						eff:SetCost(function(e,tp,eg,ep,ev,re,r,rp,chk)
								if chk==0 then
									return cost(e,tp,eg,ep,ev,re,r,rp,0)
								end
								s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
								NTR_Effect_Blacklotus=true
								cost(e,tp,eg,ep,ev,re,r,rp,chk)
								NTR_Effect_Blacklotus=false
								return
						end)
					else
						eff:SetCost(s.cost)
					end
					if target then
						eff:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
								if chkc==0 then
									return target(e,tp,eg,ep,ev,re,r,rp,chk,0)
								end
								if chk==0 then
									return target(e,tp,eg,ep,ev,re,r,rp,0,chkc)
								end
								NTR_Effect_Blacklotus=true
								target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
								NTR_Effect_Blacklotus=false
								return
						end)
					end
					if operation then
						eff:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)	   
								NTR_Effect_Blacklotus=true
								operation(e,tp,eg,ep,ev,re,r,rp)
								NTR_Effect_Blacklotus=false
								return
						end)
					end
				end
	return eff
end
function s.adjustop(e,tp,eg,ep,ev,re,r,rp)
	--
	if not s.globle_check then
		local c=e:GetHandler()
		Duel.ConfirmCards(0,c)
		Duel.Hint(HINT_CARD,0,id)
		--
		s.globle_check=true
		--change effect type
		local e01=Effect.CreateEffect(c)
		e01:SetType(EFFECT_TYPE_FIELD)
		e01:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_PLAYER_TARGET)
		e01:SetCode(id)
		e01:SetTargetRange(1,0)
		Duel.RegisterEffect(e01,0)
		--public
		local e02=Effect.CreateEffect(c)
		e02:SetType(EFFECT_TYPE_FIELD)
		e02:SetCode(EFFECT_PUBLIC)
		e02:SetTargetRange(0,LOCATION_HAND)
		Duel.RegisterEffect(e02,0)
		--
		local g=Duel.GetMatchingGroup(s.filter,0,0xff,0xff,nil)
		NTR_Effect_Blacklotus=false
		cregister=Card.RegisterEffect
		csetuniqueonfield=Card.SetUniqueOnField
		cenablecounterpermit=Card.EnableCounterPermit
		ecreateeffect=Effect.CreateEffect
		table_effect={}
		Card.RegisterEffect=function(card,effect,flag)
			if effect then
				table.insert(table_effect,s.NTR_Reform(effect))
			end
			return 
		end
		Card.SetUniqueOnField=function(card,s,o,int,location)
			NTR_Effect_Unique=true
			return
		end
		Card.EnableCounterPermit=function(card,countertype,location)
			NTR_Effect_Counter=countertype
			return
		end
		for tc in aux.Next(g) do
			table_effect={}
			NTR_Effect_Counter=0
			NTR_Effect_Unique=false
			tc:ReplaceEffect(id,0)
			Duel.CreateToken(0,tc:GetOriginalCode())
			for key,eff in ipairs(table_effect) do
				cregister(tc,eff)
			end
			if NTR_Effect_Counter~=0 then cenablecounterpermit(tc,NTR_Effect_Counter) end
			if NTR_Effect_Unique then csetuniqueonfield(tc,1,0,tc:GetOriginalCode()) end
		end
		Card.RegisterEffect=cregister
		Card.SetUniqueOnField=csetuniqueonfield
		Card.EnableCounterPermit=cenablecounterpermit
		Effect.CreateEffect=ecreateeffect
		--Select Change
		local _SelectMatchingCard=Duel.SelectMatchingCard
		local _SelectReleaseGroup=Duel.SelectReleaseGroup
		local _SelectReleaseGroupEx=Duel.SelectReleaseGroupEx
		local _SelectTarget=Duel.SelectTarget
		local _SelectTribute=Duel.SelectTribute
		local _DiscardHand=Duel.DiscardHand
		local _DRemoveOverlayCard=Duel.RemoveOverlayCard
		local _DAnnounceCard=Duel.AnnounceCard
		local _DConfirmCards=Duel.ConfirmCards
		local _DSpecialSummon=Duel.SpecialSummon
		local _DSpecialSummonStep=Duel.SpecialSummonStep
		local _DHint=Duel.Hint
		local _CRemoveOverlayCard=Card.RemoveOverlayCard
		local _FilterSelect=Group.FilterSelect
		local _Select=Group.Select
		local _SelectUnselect=Group.SelectUnselect
		function Duel.SelectMatchingCard(sp,f,p,s,o,min,max,nc,...)
			if NTR_Effect_Blacklotus then
				if (s&LOCATION_EXTRA)>0 or (s&LOCATION_DECK)>0 then
					local g=Duel.GetFieldGroup(sp,s,0)
					_DConfirmCards(1-sp,g)
				end
				return _SelectMatchingCard(1-sp,f,p,s,o,min,max,nc,...)
			else
				return _SelectMatchingCard(sp,f,p,s,o,min,max,nc,...)
			end
		end
		function Duel.SelectReleaseGroup(sp,f,min,max,nc,...)
			if NTR_Effect_Blacklotus then
				return _SelectReleaseGroup(1-sp,f,min,max,nc,...)
			else
				return _SelectReleaseGroup(sp,f,min,max,nc,...)
			end
		end
		function Duel.SelectReleaseGroupEx(sp,f,min,max,nc,...)
			if NTR_Effect_Blacklotus then
				return _SelectReleaseGroupEx(1-sp,f,min,max,nc,...)
			else
				return _SelectReleaseGroupEx(sp,f,min,max,nc,...)
			end
		end
		function Duel.SelectTarget(sp,f,p,s,o,min,max,nc,...)
			if NTR_Effect_Blacklotus then
				if (s&LOCATION_EXTRA)>0 or (s&LOCATION_DECK)>0 then
					local g=Duel.GetFieldGroup(sp,s,0)
					_DConfirmCards(1-sp,g)
				end
				return _SelectTarget(1-sp,f,p,s,o,min,max,nc,...)
			else
				return _SelectTarget(sp,f,p,s,o,min,max,nc,...)
			end
		end
		function Duel.SelectTribute(sp,ac,min,max,mg,top)
			if NTR_Effect_Blacklotus then
				return _SelectTribute(1-sp,ac,min,max,mg,top)
			else
				return _SelectTribute(sp,ac,min,max,mg,top)
			end
		end
		function Duel.DiscardHand(sp,f,min,max,r,nc,...)
			if NTR_Effect_Blacklotus then
				local g=Duel.GetMatchingGroup(f,sp,LOCATION_HAND,0,nc,...)
				local dg=g:Select(1-sp,min,max,nc)
				return Duel.SendtoGrave(dg,r+REASON_DISCARD)
			else
				return _DiscardHand(sp,f,min,max,r,nc,...)
			end
		end
		function Duel.RemoveOverlayCard(sp,s,o,min,max,r)
			if NTR_Effect_Blacklotus then
				if (s&LOCATION_EXTRA)>0 or (s&LOCATION_DECK)>0 then
					local g=Duel.GetFieldGroup(sp,s,0)
					_DConfirmCards(1-sp,g)
				end
				return _DRemoveOverlayCard(1-sp,s,o,min,max,r)
			else
				return _DRemoveOverlayCard(sp,s,o,min,max,r)
			end
		end
		function Duel.AnnounceCard(sp,int)
			if NTR_Effect_Blacklotus then
				return _DAnnounceCard(1-sp,int)
			else
				return _DAnnounceCard(sp,int)
			end
		end
		function Duel.ConfirmCards(sp,tg)
			if NTR_Effect_Blacklotus then
				return _DConfirmCards(sp,tg) and _DConfirmCards(1-sp,tg)
			else
				return _DConfirmCards(sp,tg)
			end
		end
		function Duel.SpecialSummon(tg,type,sp,tp,check,limit,pos,...)
			if NTR_Effect_Blacklotus then
				return _DSpecialSummon(tg,type,1-sp,tp,check,limit,pos,...)
			else
				return _DSpecialSummon(tg,type,sp,tp,check,limit,pos,...)
			end
		end
		function Duel.SpecialSummonStep(tg,type,sp,tp,check,limit,pos,...)
			if NTR_Effect_Blacklotus then
				return _DSpecialSummonStep(tg,type,1-sp,tp,check,limit,pos,...)
			else
				return _DSpecialSummonStep(tg,type,sp,tp,check,limit,pos,...)
			end
		end
		function Duel.Hint(type,sp,desc)
			if NTR_Effect_Blacklotus then
				return _DHint(type,1-sp,desc)
			else
				return _DHint(type,sp,desc)
			end
		end
		function Card.RemoveOverlayCard(oc,sp,min,max,r)
			if NTR_Effect_Blacklotus then
				return _CRemoveOverlayCard(oc,1-sp,min,max,r)
			else
				return _CRemoveOverlayCard(oc,sp,min,max,r)
			end
		end
		function Group.FilterSelect(g,sp,f,min,max,nc,...)
			if NTR_Effect_Blacklotus then
				if g:Filter(Card.IsLocation,nil,LOCATION_DECK+LOCATION_HAND):GetCount()>0 then
					local g=Duel.GetFieldGroup(sp,s,0)
					_DConfirmCards(1-sp,g)
				end
				return _FilterSelect(g,1-sp,f,min,max,nc,...)
			else
				return _FilterSelect(g,sp,f,min,max,nc,...)
			end
		end
		function Group.Select(g,sp,min,max,nc)
			if NTR_Effect_Blacklotus then
				if g:Filter(Card.IsLocation,nil,LOCATION_DECK+LOCATION_HAND):GetCount()>0 then
					local g=Duel.GetFieldGroup(sp,s,0)
					_DConfirmCards(1-sp,g)
				end
				return _Select(g,1-sp,min,max,nc)
			else
				return _Select(g,sp,min,max,nc)
			end
		end
		function Group.SelectUnselect(cg,sg,sp,btok,cancelable,min,max)
			if NTR_Effect_Blacklotus then
				return _SelectUnselect(cg,sg,1-sp,btok,cancelable,min,max)
			else
				return _SelectUnselect(cg,sg,sp,btok,cancelable,min,max)
			end
		end
		--Summon
		local ge1=Effect.CreateEffect(c)
		ge1:SetDescription(aux.Stringid(id,0))
		ge1:SetType(EFFECT_TYPE_IGNITION+EFFECT_TYPE_CONTINUOUS)
		ge1:SetRange(LOCATION_HAND)
		ge1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_BOTH_SIDE)
		ge1:SetCondition(s.sumcon)
		--ge1:SetTarget(s.sumtarget)
		ge1:SetOperation(s.sumactivate)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
		ge2:SetTargetRange(LOCATION_HAND,LOCATION_HAND)
		--ge2:SetTarget(s.sumtg)
		ge2:SetLabelObject(ge1)
		Duel.RegisterEffect(ge2,0)
		--SpecialSummon
		--local ge3=Effect.CreateEffect(c)
		--ge3:SetDescription(aux.Stringid(id,1))
		--ge3:SetType(EFFECT_TYPE_IGNITION+EFFECT_TYPE_CONTINUOUS)
		--ge3:SetRange(LOCATION_HAND+LOCATION_EXTRA)
		--ge3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_BOTH_SIDE)
		--ge3:SetCondition(s.spcon)
		--ge3:SetTarget(s.sptarget)
		--ge3:SetOperation(s.spactivate)
		--local ge4=Effect.CreateEffect(c)
		--ge4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
		--ge4:SetTargetRange(LOCATION_HAND+LOCATION_EXTRA,LOCATION_HAND+LOCATION_EXTRA)
		--ge4:SetTarget(s.sptg)
		--ge4:SetLabelObject(ge3)
		--Duel.RegisterEffect(ge4,0)
		--Spell Activate or set
		local ge5=Effect.CreateEffect(c)
		ge5:SetDescription(aux.Stringid(id,5))
		ge5:SetType(EFFECT_TYPE_IGNITION+EFFECT_TYPE_CONTINUOUS)
		ge5:SetRange(LOCATION_HAND)
		ge5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_BOTH_SIDE)
		ge5:SetCondition(s.sactcon)
		--ge5:SetTarget(s.sacttarget)
		ge5:SetOperation(s.sactactivate)
		local ge6=Effect.CreateEffect(c)
		ge6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
		ge6:SetTargetRange(LOCATION_HAND,LOCATION_HAND)
		ge6:SetTarget(s.sacttg)
		ge6:SetLabelObject(ge5)
		Duel.RegisterEffect(ge6,0)
		--Spell Activate when set
		local ge7=Effect.CreateEffect(c)
		ge7:SetDescription(aux.Stringid(id,5))
		ge7:SetType(EFFECT_TYPE_IGNITION+EFFECT_TYPE_CONTINUOUS)
		ge7:SetRange(LOCATION_SZONE)
		ge7:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_BOTH_SIDE+EFFECT_FLAG_SET_AVAILABLE)
		ge7:SetCondition(s.sactcon2)
		--ge7:SetTarget(s.sacttarget)
		ge7:SetOperation(s.sactactivate2)
		local ge8=Effect.CreateEffect(c)
		ge8:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
		ge7:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		ge8:SetTargetRange(LOCATION_SZONE,LOCATION_SZONE)
		ge8:SetTarget(s.sacttg2)
		ge8:SetLabelObject(ge7)
		Duel.RegisterEffect(ge8,0)
		local ge9=ge8:Clone()
		Duel.RegisterEffect(ge9,1)
		--SpecialSummon from ex
		local ge10=Effect.CreateEffect(c)
		ge10:SetType(EFFECT_TYPE_IGNITION+EFFECT_TYPE_CONTINUOUS)
		ge10:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		ge10:SetTarget(s.sptarget2)
		ge10:SetOperation(s.spactivate2)
		Duel.RegisterEffect(ge10,0)
	end
	e:Reset()
end
function s.sumtg(e,c)
	return (c:IsSummonable(false,nil) or c:IsMSetable(false,nil))
end
function s.sumcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsPlayerAffectedByEffect(tp,id) and tp~=e:GetHandler():GetOwner() and (e:GetHandler():IsSummonable(false,nil) or e:GetHandler():IsMSetable(false,nil))
end
function s.sumtarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerAffectedByEffect(tp,id) and tp~=e:GetHandler():GetOwner() and (e:GetHandler():IsSummonable(false,nil) or e:GetHandler():IsMSetable(false,nil)) end
end
function s.sumactivate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local s1=c:IsSummonable(false,nil)
	local s2=c:IsMSetable(false,nil)
	if (s1 and s2 and Duel.SelectPosition(1-tp,c,POS_FACEUP_ATTACK+POS_FACEDOWN_DEFENSE)==POS_FACEUP_ATTACK) or (s1 and not s2) then
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TOZONE)
		local zone=Duel.SelectDisableField(1-tp,1,0,LOCATION_MZONE,0)/0x10000
		Duel.Summon(tp,c,false,nil,0,zone)
	elseif s2 then
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TOZONE)
		local zone=Duel.SelectDisableField(1-tp,1,0,LOCATION_MZONE,0)/0x10000
		Duel.MSet(tp,c,false,nil,0,zone)
	end
end
function s.sptg(e,c)
	return c:IsSpecialSummonable() or c:IsSynchroSummonable(nil) or c:IsXyzSummonable(nil) or c:IsLinkSummonable(nil)
end
function s.sptarget(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsSpecialSummonable() or c:IsSynchroSummonable(nil) or c:IsXyzSummonable(nil) or c:IsLinkSummonable(nil) end
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Duel.IsPlayerAffectedByEffect(tp,id) and tp~=e:GetHandler():GetOwner() and (c:IsSpecialSummonable() or c:IsSynchroSummonable(nil) or c:IsXyzSummonable(nil) or c:IsLinkSummonable(nil))
end
function s.spactivate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local s1=c:IsSpecialSummonable()
	local s2=c:IsSynchroSummonable(nil)
	local s3=c:IsXyzSummonable(nil)
	local s4=c:IsLinkSummonable(nil)
	local off=1
	local op=0
	local ops={}
	local opval={}
	opval[0]=0
	if s1 then
		ops[off]=aux.Stringid(id,2)
		opval[off-1]=1
		off=off+1
	end
	if s2 then
		ops[off]=aux.Stringid(id,3)
		opval[off-1]=2
		off=off+1
	end
	if s3 then
		ops[off]=aux.Stringid(id,4)
		opval[off-1]=3
		off=off+1
	end
	if s4 then
		ops[off]=aux.Stringid(id,5)
		opval[off-1]=4
		off=off+1
	end
	if off>2 then op=Duel.SelectOption(1-tp,table.unpack(ops)) end
	NTR_Effect_Blacklotus=true
	if opval[op]==1 then
		Duel.SpecialSummonRule(tp,c)
	elseif opval[op]==2 then
		Duel.SynchroSummon(tp,c,nil)
	elseif opval[op]==3 then
		Duel.XyzSummon(tp,c,nil)
	elseif opval[op]==4 then
		Duel.LinkSummon(tp,c,nil)
	end
	NTR_Effect_Blacklotus=false
end
function s.sfilter(c)
	return c:IsSpecialSummonable() or c:IsSynchroSummonable(nil) or c:IsXyzSummonable(nil) or c:IsLinkSummonable(nil)
end
function s.sptarget2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.sfilter,tp,0,LOCATION_EXTRA+LOCATION_HAND,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA+LOCATION_HAND)
end
function s.spactivate2(e,tp,eg,ep,ev,re,r,rp)
	local cg=Duel.GetFieldGroup(tp,0,LOCATION_EXTRA+LOCATION_HAND)
	Duel.ConfirmCards(tp,cg)
	local g=Duel.GetMatchingGroup(s.sfilter,tp,0,LOCATION_EXTRA+LOCATION_HAND,nil)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local c=g:Select(tp,1,1,nil):GetFirst()
		local s1=c:IsSpecialSummonable()
		local s2=c:IsSynchroSummonable(nil)
		local s3=c:IsXyzSummonable(nil)
		local s4=c:IsLinkSummonable(nil)
		local off=1
		local op=0
		local ops={}
		local opval={}
		opval[0]=0
		if s1 then
			ops[off]=aux.Stringid(id,1)
			opval[off-1]=1
			off=off+1
		end
		if s2 then
			ops[off]=aux.Stringid(id,2)
			opval[off-1]=2
			off=off+1
		end
		if s3 then
			ops[off]=aux.Stringid(id,3)
			opval[off-1]=3
			off=off+1
		end
		if s4 then
			ops[off]=aux.Stringid(id,4)
			opval[off-1]=4
			off=off+1
		end
		if off>2 then op=Duel.SelectOption(1-tp,table.unpack(ops)) end
		NTR_Effect_Blacklotus=true
		if opval[op]==1 then
			Duel.SpecialSummonRule(1-tp,c)
		elseif opval[op]==2 then
			Duel.SynchroSummon(1-tp,c,nil)
		elseif opval[op]==3 then
			Duel.XyzSummon(1-tp,c,nil)
		elseif opval[op]==4 then
			Duel.LinkSummon(1-tp,c,nil)
		end
		NTR_Effect_Blacklotus=false
	end
end
function s.sacttg(e,c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function s.sactcon(e,tp)
	local c=e:GetHandler()
	if not c:IsType(TYPE_SPELL+TYPE_TRAP) then return false end
	local res=false
	if c:IsType(TYPE_SPELL) and not c:IsType(TYPE_QUICKPLAY) and c:GetActivateEffect():GetCode()==EVENT_FREE_CHAIN then
		res=c:GetActivateEffect():IsActivatable(1-tp,true)
	end
	if c:IsType(TYPE_FIELD) then
		return Duel.IsPlayerAffectedByEffect(tp,id) and tp~=e:GetHandler():GetOwner() and ((res and c:IsType(TYPE_SPELL)) or c:IsSSetable())
	end
	return Duel.IsPlayerAffectedByEffect(tp,id) and tp~=e:GetHandler():GetOwner()  and ((res and c:IsType(TYPE_SPELL) and not c:IsType(TYPE_QUICKPLAY)) or c:IsSSetable()) and Duel.GetLocationCount(1-tp,LOCATION_SZONE)>0
end
function s.sacttarget(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return not c:IsType(TYPE_QUICKPLAY) and c:IsType(TYPE_SPELL+TYPE_TRAP) end
end
function s.sactactivate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local s1=c:IsType(TYPE_SPELL) and not c:IsType(TYPE_QUICKPLAY) and c:GetActivateEffect():IsActivatable(tp,true)
	local s2=c:IsSSetable()
	local off=1
	local op=1
	local ops={}
	local opval={}
	if s1 and s2 then
		if s1 then
			ops[off]=aux.Stringid(id,6)
			opval[off-1]=1
			off=off+1
		end
		if s2 then
			ops[off]=aux.Stringid(id,7)
			opval[off-1]=2
			off=off+1
		end
		op=Duel.SelectOption(1-tp,table.unpack(ops))
	elseif s1 and not s2 then
		opval[1]=1
		op=1
	elseif s2 and not s1 then
		opval[1]=2
		op=1
	else return false
	end
	if opval[op]==1 then
		if c:IsType(TYPE_FIELD) then
			local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
			if fc then
				Duel.SendtoGrave(fc,REASON_RULE)
				Duel.BreakEffect()
			end
			Duel.MoveToField(c,1-tp,tp,LOCATION_FZONE,POS_FACEUP,true)
		else
			Duel.MoveToField(c,1-tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		end
		local e1=e:GetHandler():GetActivateEffect()
		e1:UseCountLimit(tp)
		local e2=s.NTR_Reform2(e1)
		e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
		e2:SetRange(LOCATION_SZONE)
		if c:IsType(TYPE_FIELD) then
			e2:SetRange(LOCATION_FZONE)
		end
		e2:SetCode((id+c:GetOriginalCode()))
		e2:SetReset(RESET_EVENT+RESET_CHAIN)
		c:RegisterEffect(e2)
		Duel.RaiseSingleEvent(e:GetHandler(),(id+c:GetOriginalCode()),re,r,1-tp,1-tp,ev)
	elseif opval[op]==2 then
		Duel.SSet(1-tp,c,tp,false)
	end

end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	e:SetType(EFFECT_TYPE_ACTIVATE)
	local ge3=Effect.CreateEffect(e:GetHandler())
	ge3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	ge3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	ge3:SetCode(EVENT_CHAIN_SOLVED)
	ge3:SetLabelObject(e)
	ge3:SetReset(RESET_PHASE+PHASE_END)
	ge3:SetOperation(s.resetop)
	Duel.RegisterEffect(ge3,tp)
	local ge4=ge3:Clone()
	ge4:SetCode(EVENT_CHAIN_NEGATED)
	Duel.RegisterEffect(ge4,tp)
end
function s.reset(e,tp,eg,ep,ev,re,r,rp)
	if re==e:GetLabelObject() and re:IsHasType(EFFECT_TYPE_ACTIVATE) then
		e:Reset()
		re:Reset()
	end
end
function s.sacttg2(e,c)
	return c:IsType(TYPE_SPELL) and not c:IsType(TYPE_QUICKPLAY) and c:IsFacedown()
end
function s.sactcon2(e,tp)
	local c=e:GetHandler()
	if not c:IsType(TYPE_SPELL) then return false end
	local res=false
	if c:IsType(TYPE_SPELL) and not c:IsType(TYPE_QUICKPLAY) and c:GetActivateEffect():GetCode()==EVENT_FREE_CHAIN then
		res=c:GetActivateEffect():IsActivatable(1-tp,true)
	end
	Debug.Message("1")
	if c:IsType(TYPE_FIELD) then
		return Duel.IsPlayerAffectedByEffect(tp,id) and tp~=e:GetHandler():GetOwner() and res 
	end
	return Duel.IsPlayerAffectedByEffect(tp,id) and tp~=e:GetHandler():GetOwner()  and res
end
function s.sactactivate2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local s1=c:IsType(TYPE_SPELL) and not c:IsType(TYPE_QUICKPLAY) and c:GetActivateEffect():IsActivatable(tp,true)
	if s1 then
		c:ChangePosition(POS_FACEUP)
		local e1=e:GetHandler():GetActivateEffect()
		e1:UseCountLimit(tp)
		local e2=s.NTR_Reform2(e1)
		e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
		e2:SetRange(LOCATION_SZONE)
		if c:IsType(TYPE_FIELD) then
			e2:SetRange(LOCATION_FZONE)
		end
		e2:SetCode((id+c:GetOriginalCode()))
		e2:SetReset(RESET_EVENT+RESET_CHAIN)
		c:RegisterEffect(e2)
		Duel.RaiseSingleEvent(e:GetHandler(),(id+c:GetOriginalCode()),re,r,1-tp,1-tp,ev)
	end

end
