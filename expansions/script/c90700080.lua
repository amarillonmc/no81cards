local m=90700080
local cm=_G["c"..m]
cm.name="红莲花"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
cm.ad={100,200,300,400,500,600,700,800,900,1000}
function cm.check_race(tp)
	local res=0
	local r=1
	while bit.band(RACE_ALL,r)~=0 do
		local attr=cm.check_attr(tp,r)
		if attr>0 then
			res=res+r
		end
		r=r*2
	end
	return res
end
function cm.check_attr(tp,r)
	local res=0
	local attr=1
	for i=0,7 do
		local g=cm.check_lvl(tp,r,attr)
		if #g<12 then
			res=res+attr
		end
		attr=attr*2
	end
	return res
end
function cm.check_lvl(tp,r,attr)
	local res={}
	for lvl=1,12 do
		if not cm.check_token(tp,r,attr,lvl) then
			table.insert(res,lvl)
		end
	end
	return res
end
function cm.check_token(tp,r,attr,lv)
	return Duel.IsPlayerCanSpecialSummonMonster(tp,m+1,0,TYPES_TOKEN_MONSTER,0,0,lv,r,attr)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return cm.check_race(tp)>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local time=3
	while time>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and cm.check_race(tp)>0 do
		if time<3 and not Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
			time=0
			goto continue
		end
		time=time-1
		local r=Duel.AnnounceRace(tp,1,cm.check_race(tp))
		local attr=Duel.AnnounceAttribute(tp,1,cm.check_attr(tp,r))
		local lv=Duel.AnnounceLevel(tp,1,12,table.unpack(cm.check_lvl(tp,r,attr)))
		local token=Duel.CreateToken(tp,m+1)
		Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_ATTRIBUTE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e1:SetValue(attr)
		token:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_CHANGE_LEVEL)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e2:SetValue(lv)
		token:RegisterEffect(e2)
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_CHANGE_RACE)
		e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e3:SetValue(r)
		token:RegisterEffect(e3)
		Duel.SpecialSummonComplete()
		if Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
			local e4=Effect.CreateEffect(e:GetHandler())
			e4:SetType(EFFECT_TYPE_SINGLE)
			e4:SetCode(EFFECT_SET_BASE_ATTACK)
			local atk,num=Duel.AnnounceNumber(tp,table.unpack(cm.ad))
			e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
			e4:SetValue(atk)
			e4:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
			token:RegisterEffect(e4)
		end
		if Duel.SelectYesNo(tp,aux.Stringid(m,2)) then
			local e5=Effect.CreateEffect(e:GetHandler())
			e5:SetType(EFFECT_TYPE_SINGLE)
			e5:SetCode(EFFECT_SET_BASE_DEFENSE)
			local def,num=Duel.AnnounceNumber(tp,table.unpack(cm.ad))
			e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
			e5:SetValue(def)
			e5:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
			token:RegisterEffect(e5)
		end
		if Duel.SelectYesNo(tp,aux.Stringid(m,3)) then
			Duel.BreakEffect()
			local e6=Effect.CreateEffect(e:GetHandler())
			e6:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
			e6:SetType(EFFECT_TYPE_SINGLE)
			e6:SetCode(EFFECT_ADD_TYPE)
			e6:SetValue(TYPE_TUNER)
			token:RegisterEffect(e6)
		end
		:: continue ::
	end
end