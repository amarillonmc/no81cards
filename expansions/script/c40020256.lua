--创界神 密特拉
local s,id=GetID()
s.named_with_Grandwalker=1
s.named_with_Hindida=1
function s.Grandwalker(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Grandwalker
end
function s.Hindida(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Hindida
end
function s.AwakenedDragon(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_AwakenedDragon
end

function s.initial_effect(c)

	aux.EnablePendulumAttribute(c)

	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.thsptg)
	e1:SetOperation(s.thspop)
	c:RegisterEffect(e1)

	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_SOLVING)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCondition(s.solvecon)
	e2:SetOperation(s.solveop)
	c:RegisterEffect(e2)

	if not s.global_check then
		s.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_TO_GRAVE)
		ge1:SetOperation(s.checkop)
		Duel.RegisterEffect(ge1,0)
	end
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_EXTRA)
	e3:SetCountLimit(1,id+100)
	e3:SetCondition(s.pzcon)
	e3:SetTarget(s.pztg)
	e3:SetOperation(s.pzop)
	c:RegisterEffect(e3)
end

function s.rmfilter(c,e,tp)
	if not (c:IsFaceup() and s.AwakenedDragon(c)) then return false end
	local b1 = c:IsAbleToHand()
	local b2 = c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	return b1 or b2
end

function s.thsptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.rmfilter,tp,LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,0,tp,LOCATION_REMOVED)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,0,tp,LOCATION_REMOVED)
end

function s.thspop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SelectMatchingCard(tp,s.rmfilter,tp,LOCATION_REMOVED,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc then
		local b1=tc:IsAbleToHand()
		local b2=tc:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		local op=0
		if b1 and b2 then
			op=Duel.SelectOption(tp,aux.Stringid(id,2),aux.Stringid(id,3))
		elseif b1 then
			op=0
		else
			op=1
		end
		if op==0 then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		else
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end

function s.costfilter(c)
	return s.AwakenedDragon(c) and c:IsAbleToRemove()
end

function s.solvecon(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,id+1)>0 then return false end
	return Duel.IsExistingMatchingCard(s.costfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil)
end

function s.rm_xyz_mat_filter(c)
	return c:IsFaceup() and s.AwakenedDragon(c) and c:IsType(TYPE_MONSTER)
end

function s.xyzcon_grant(e,c,og,min,max)
	if c==nil then return true end
	local tp=c:GetControler()
	if Duel.GetFlagEffect(tp, c:GetCode()+id) > 0 then return false end
	
	local g=Duel.GetMatchingGroup(s.rm_xyz_mat_filter,tp,LOCATION_REMOVED,0,nil)
	return #g>0 and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end

function s.xyztg_grant(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local g=Duel.GetMatchingGroup(s.rm_xyz_mat_filter,tp,LOCATION_REMOVED,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local tc=g:Select(tp,1,1,nil):GetFirst()
	if tc then
		c:SetMaterial(Group.FromCards(tc))
		e:SetLabelObject(tc)
		return true
	end
	return false
end

function s.xyzop_grant(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.RegisterFlagEffect(tp, c:GetCode()+id, RESET_PHASE+PHASE_END, 0, 1)
	local tc=e:GetLabelObject()
	if tc then
		Duel.Overlay(c, Group.FromCards(tc))
		e:SetLabelObject(nil)
	end
end

function s.normal_xyz_filter(c)
	return s.AwakenedDragon(c) and c:IsType(TYPE_XYZ) and c:IsXyzSummonable(nil)
end

function s.alt_xyz_filter(c,e,tp)
	if not (s.AwakenedDragon(c) and c:IsType(TYPE_XYZ)) then return false end
	if Duel.GetFlagEffect(tp, c:GetCode()+id) > 0 then return false end
	local mat_exist = Duel.IsExistingMatchingCard(s.rm_xyz_mat_filter,tp,LOCATION_REMOVED,0,1,nil)
	local has_space = Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
	local can_sp = c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
	return mat_exist and has_space and can_sp
end

function s.any_xyz_filter(c,e,tp)
	return s.normal_xyz_filter(c) or s.alt_xyz_filter(c,e,tp)
end

function s.solveop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetFlagEffect(tp,id+1)==0 
		and Duel.SelectEffectYesNo(tp,c,aux.Stringid(id,4)) then 
		
		Duel.Hint(HINT_CARD,0,id)
		Duel.RegisterFlagEffect(tp,id+1,RESET_PHASE+PHASE_END,0,1)
		
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectMatchingCard(tp,s.costfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil)
		if #g>0 and Duel.Remove(g,POS_FACEUP,REASON_EFFECT)>0 then
			
			local sp_eff=Effect.CreateEffect(c)
			sp_eff:SetDescription(aux.Stringid(id,5))
			sp_eff:SetType(EFFECT_TYPE_FIELD)
			sp_eff:SetCode(EFFECT_SPSUMMON_PROC)
			sp_eff:SetProperty(EFFECT_FLAG_UNCOPYABLE)
			sp_eff:SetRange(LOCATION_EXTRA)
			sp_eff:SetCondition(s.xyzcon_grant)
			sp_eff:SetTarget(s.xyztg_grant)
			sp_eff:SetOperation(s.xyzop_grant)
			sp_eff:SetValue(SUMMON_TYPE_XYZ)
			
			local grant_eff=Effect.CreateEffect(c)
			grant_eff:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
			grant_eff:SetTargetRange(LOCATION_EXTRA,0)
			grant_eff:SetTarget(s.extg)
			grant_eff:SetLabelObject(sp_eff)
			grant_eff:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(grant_eff,tp)
			Duel.BreakEffect()
			
			local xyzg=Duel.GetMatchingGroup(s.any_xyz_filter,tp,LOCATION_EXTRA,0,nil,e,tp)
			if #xyzg>0 and Duel.SelectYesNo(tp,aux.Stringid(id,6)) then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local sc=xyzg:Select(tp,1,1,nil):GetFirst()
				if not sc then return end
				local b_normal = s.normal_xyz_filter(sc)
				local b_alt	= s.alt_xyz_filter(sc,e,tp)
				local use_alt = false
				
				if b_normal and b_alt then
					use_alt = Duel.SelectYesNo(tp, aux.Stringid(id,5))
				elseif b_alt then
					use_alt = true
				else
					use_alt = false
				end
				if not use_alt then
					Duel.XyzSummon(tp,sc,nil)
				else
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
					local mat_g = Duel.GetMatchingGroup(s.rm_xyz_mat_filter,tp,LOCATION_REMOVED,0,nil)
					local mat = mat_g:Select(tp,1,1,nil):GetFirst()
					if mat then
						sc:SetMaterial(Group.FromCards(mat))
						if Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)~=0 then
							Duel.Overlay(sc,Group.FromCards(mat))
							sc:CompleteProcedure()
							Duel.RegisterFlagEffect(tp, sc:GetCode()+id, RESET_PHASE+PHASE_END, 0, 1)
						end
					end
				end
			end
		end
	end
end

function s.extg(e,c)
	return c:IsType(TYPE_XYZ) and s.AwakenedDragon(c)
end

function s.rm_xyz_mat_filter(c)
	return c:IsFaceup() and s.AwakenedDragon(c) and c:IsType(TYPE_MONSTER)
end

function s.xyzcon_grant(e,c,og,min,max)
	if c==nil then return true end
	local tp=c:GetControler()
	if Duel.GetFlagEffect(tp, c:GetCode()+id) > 0 then return false end
	
	local g=Duel.GetMatchingGroup(s.rm_xyz_mat_filter,tp,LOCATION_REMOVED,0,nil)
	return #g>0 and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end

function s.xyztg_grant(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local g=Duel.GetMatchingGroup(s.rm_xyz_mat_filter,tp,LOCATION_REMOVED,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local tc=g:Select(tp,1,1,nil):GetFirst()
	if tc then
		c:SetMaterial(Group.FromCards(tc))
		e:SetLabelObject(tc)
		return true
	end
	return false
end

function s.xyzop_grant(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.RegisterFlagEffect(tp, c:GetCode()+id, RESET_PHASE+PHASE_END, 0, 1)
	local tc=e:GetLabelObject()
	if tc then
		Duel.Overlay(c, Group.FromCards(tc))
		e:SetLabelObject(nil)
	end
end


function s.checkop(e,tp,eg,ep,ev,re,r,rp)
	if not re then return end
	local rc=re:GetHandler()
	if s.Grandwalker(rc) and eg:IsExists(Card.IsPreviousLocation,1,nil,LOCATION_DECK) then
		Duel.RegisterFlagEffect(rp,id,RESET_PHASE+PHASE_END,0,1)
	end
end
function s.pzcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsFaceup()
end
function s.pztg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.CheckLocation(tp,LOCATION_PZONE,0)
			or Duel.CheckLocation(tp,LOCATION_PZONE,1)
	end
end
function s.pzop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if not (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) then
		return
	end
	if Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true) then
		if Duel.GetFlagEffect(tp,id)==0 then
			if Duel.IsPlayerCanDiscardDeck(tp,3) and Duel.SelectYesNo(tp,aux.Stringid(id,7)) then
				Duel.BreakEffect()
				Duel.DiscardDeck(tp,3,REASON_EFFECT)
			end
		end
	end
end

