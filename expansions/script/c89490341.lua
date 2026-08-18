--疑散虚符族·玛斯普罗克西哈特
local s,id,o=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(1165)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(s.XyzCondition(nil,8,2,2,s.ovfilter,aux.Stringid(id,0),s.xyzop))
	e1:SetTarget(s.XyzTarget(nil,8,2,2,s.ovfilter,aux.Stringid(id,0),s.xyzop))
	e1:SetOperation(s.XyzOperation(nil,8,2,2,s.ovfilter,aux.Stringid(id,0),s.xyzop))
	e1:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e1)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_CANNOT_ATTACK)
	e4:SetCondition(s.con2)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_ATTACK_ALL)
	e5:SetCondition(aux.NOT(s.con2))
	e5:SetValue(1)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EFFECT_CHANGE_BATTLE_DAMAGE)
	e6:SetCondition(s.damcon)
	e6:SetValue(aux.ChangeBattleDamage(1,DOUBLE_DAMAGE))
	c:RegisterEffect(e6)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EFFECT_SEND_REPLACE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTarget(s.reptg)
	e4:SetValue(aux.TRUE)
	c:RegisterEffect(e4)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,1))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(s.poscost)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	if not s.global_check then
		s.global_check=true
		Duel.DiscardDeck=function(tp,ct,r)
			local g=Duel.GetDecktopGroup(tp,ct)
			Duel.DisableShuffleCheck()
			return Duel.SendtoGrave(g,r)
		end
	end
end
function s.ovfilter(c)
	return c:IsFaceup() and c:IsRankBelow(7) and c:IsSetCard(0xc3d)
end
function s.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,id)==0 end
	Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end
function s.con2(e)
	return e:GetHandler():GetOverlayCount()<=2
end
function s.damcon(e)
	return not s.con2(e) and e:GetHandler():GetBattleTarget()~=nil
end
function s.raval(e,c)
	return e:GetHandler():GetOverlayCount()-1
end
function s.repfilter(c,tp)
	return c:IsLocation(LOCATION_HAND+LOCATION_DECK+LOCATION_ONFIELD) and c:IsType(TYPE_MONSTER) and c:GetDestination()==LOCATION_GRAVE and c:GetOwner()==tp
end
function s.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=eg:Filter(s.repfilter,nil,1-tp)
	if chk==0 then return #g>0 end
	for tc in aux.Next(g) do
		tc:CancelToGrave()
		local og=tc:GetOverlayGroup()
		if og:GetCount()>0 then
			Duel.SendtoGrave(og,REASON_RULE)
		end
	end
	Duel.Overlay(e:GetHandler(),g)
	return true
end
function s.poscost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,15,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,15,15,REASON_COST)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsCanOverlay,tp,0,LOCATION_HAND+LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsCanOverlay,tp,0,LOCATION_HAND+LOCATION_ONFIELD,nil)
	if c:IsRelateToEffect(e) then
		for tc in aux.Next(g) do
			tc:CancelToGrave()
			local og=tc:GetOverlayGroup()
			if og:GetCount()>0 then
				Duel.SendtoGrave(og,REASON_RULE)
			end
		end
		Duel.Overlay(c,g)
	end
end

function s.XyzCondition(f,lv,minct,maxct,alterf,alterdesc,alterop)
	return	function(e,c,og,min,max)
				if c==nil then return true end
				if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
				local tp=c:GetControler()
				local mg=nil
				if og then
					mg=og
				else
					mg=Duel.GetFieldGroup(tp,LOCATION_MZONE,0)
				end
				if alterf and (not min or min<=1) then
					if mg:IsExists(aux.XyzAlterFilter,1,nil,alterf,c,e,tp,alterop) then
						return true
					end
				end
				local minc=minct
				local maxc=maxct
				if min then
					if min>minc then minc=min end
					if max<maxc then maxc=max end
				end
				if mg:IsExists(s.Xyz2XMaterialEffectFilter,1,nil,c,lv,f,tp) then
					return s.CheckXyz2XMaterial(c,f,lv,minc,maxc,mg)
				else
					if minc>maxc then return false end
					return Duel.CheckXyzMaterial(c,f,lv,minc,maxc,og)
				end
			end
end
function s.Xyz2XMaterialEffectFilter(c,xyzc,lv,f,tp,checked)
	if not checked and not aux.Xyz2XMaterialFilter(c,xyzc,lv,f) then return false end
	local e=c:IsHasEffect(EVENT_CUSTOM+89490307,tp)
	if not e then return false end
	local tg=e:GetTarget()
	if tg and not tg(e,xyzc,tp) then return false end
	return true
end
function s.CheckXyz2XMaterial(c,f,lv,minc,maxc,mg)
	local tp=c:GetControler()
	mg=mg:Filter(aux.Xyz2XMaterialFilter,nil,c,lv,f)
	local sg=Duel.GetMustMaterial(tp,EFFECT_MUST_BE_XMATERIAL)
	if sg:IsExists(aux.MustMaterialCounterFilter,1,nil,mg) then return false end
	Duel.SetSelectedCard(sg)
	aux.GCheckAdditional=aux.TuneMagicianCheckAdditionalXyz
	local res=mg:CheckSubGroup(s.Xyz2XMaterialGoal,1,maxc,tp,c,minc)
	aux.GCheckAdditional=nil
	return res
end
function s.Xyz2XMaterialGoal(g,tp,xyzc,minc)
	if Duel.GetLocationCountFromEx(tp,tp,g,xyzc)<=0 then return false end
	local lg=g:Filter(Card.IsHasEffect,nil,EFFECT_XYZ_MIN_COUNT,tp)
	for c in aux.Next(lg) do
		local le=c:IsHasEffect(EFFECT_XYZ_MIN_COUNT)
		local ct=le:GetValue()
		if #g<ct then return false end
	end
	local ct2=0
	local limit_table={}
	for c in aux.Next(g) do
		local le=c:IsHasEffect(EVENT_CUSTOM+89490307,tp)
		if le then
			local tg=le:GetTarget()
			local limit_value=le:GetValue() -- not fully implemented: assuming Hard once per turn effects
			if (not tg or tg(le,xyzc,tp)) and (not limit_value or not limit_table[limit_value]) then
				ct2=ct2+1
				if limit_value then
					limit_table[limit_value]=true
				end
			end
		end
	end
	return #g+ct2>=minc
end
function s.XyzTarget(f,lv,minct,maxct,alterf,alterdesc,alterop)
	return	function(e,tp,eg,ep,ev,re,r,rp,chk,c,og,min,max)
				if og and not min then
					return true
				end
				local minc=minct
				local maxc=maxct
				if min then
					if min>minc then minc=min end
					if max<maxc then maxc=max end
				end
				local b1=true
				local b2=false
				local altg=nil
				local mg=nil
				if og then
					mg=og
				else
					mg=Duel.GetFieldGroup(tp,LOCATION_MZONE,0)
				end
				if alterf and (not min or min<=1) then
					altg=mg:Filter(aux.XyzAlterFilter,nil,alterf,c,e,tp,alterop)
					if mg:IsExists(s.Xyz2XMaterialEffectFilter,1,nil,c,lv,f,tp) then
						b1=s.CheckXyz2XMaterial(c,f,lv,minc,maxc,mg)
					else
						b1=Duel.CheckXyzMaterial(c,f,lv,minc,maxc,og)
					end
					b2=#altg>0
				end
				local g=nil
				if b2 and (not b1 or Duel.SelectYesNo(tp,alterdesc)) then
					e:SetLabel(1)
					local cancel=Duel.IsSummonCancelable()
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
					local tc=altg:SelectUnselect(nil,tp,false,cancel,1,1)
					if tc then
						g=Group.FromCards(tc)
						if alterop then alterop(e,tp,1,tc) end
					end
				else
					e:SetLabel(0)
					if mg:IsExists(s.Xyz2XMaterialEffectFilter,1,nil,c,lv,f,tp) then
						mg=mg:Filter(aux.Xyz2XMaterialFilter,nil,c,lv,f)
						local cancel=Duel.IsSummonCancelable()
						local sg=Duel.GetMustMaterial(tp,EFFECT_MUST_BE_XMATERIAL)
						Duel.SetSelectedCard(sg)
						Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
						aux.GCheckAdditional=aux.TuneMagicianCheckAdditionalXyz
						g=mg:SelectSubGroup(tp,s.Xyz2XMaterialGoal,cancel,1,maxc,tp,c,minc)
						aux.GCheckAdditional=nil
					else
						g=Duel.SelectXyzMaterial(tp,c,f,lv,minc,maxc,og)
					end
				end
				if g then
					g:KeepAlive()
					e:SetLabelObject(g)
					return true
				else return false end
			end
end
function s.XyzOperation(f,lv,minct,maxct,alterf,alterdesc,alterop)
	return	function(e,tp,eg,ep,ev,re,r,rp,c,og,min,max)
				if og and not min then
					s.Xyz2XMaterialOperation(tp,og,c,minct,maxct)
					local sg=Group.CreateGroup()
					local tc=og:GetFirst()
					while tc do
						local sg1=tc:GetOverlayGroup()
						sg:Merge(sg1)
						tc=og:GetNext()
					end
					Duel.SendtoGrave(sg,REASON_RULE)
					c:SetMaterial(og)
					Duel.Overlay(c,og)
				else
					local mg=e:GetLabelObject()
					if e:GetLabel()==1 then
						local mg2=mg:GetFirst():GetOverlayGroup()
						if mg2:GetCount()~=0 then
							Duel.Overlay(c,mg2)
						end
					else
						s.Xyz2XMaterialOperation(tp,mg,c,minct,maxct)
						local sg=Group.CreateGroup()
						local tc=mg:GetFirst()
						while tc do
							local sg1=tc:GetOverlayGroup()
							sg:Merge(sg1)
							tc=mg:GetNext()
						end
						Duel.SendtoGrave(sg,REASON_RULE)
					end
					c:SetMaterial(mg)
					Duel.Overlay(c,mg)
					mg:DeleteGroup()
				end
			end
end
function s.Xyz2XMaterialOperation(tp,mg,xyzc,minct,maxct)
	local sg=mg:Clone()
	while #sg<minct do
		local g=sg:Filter(s.Xyz2XMaterialEffectFilter,nil,xyzc,nil,nil,tp,true)
		if #g>1 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RESOLVECARD)
			g=g:Select(tp,1,1,nil)
		end
		local tc=g:GetFirst()
		local te=tc:IsHasEffect(EVENT_CUSTOM+89490307,tp)
		Duel.Hint(HINT_CARD,0,89490307)
		te:UseCountLimit(tp)
		sg:RemoveCard(tc)
		minct=minct-2
	end
end
