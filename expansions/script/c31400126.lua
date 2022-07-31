local m=31400126
local cm=_G["c"..m]
cm.name="隐熊极天-左辅"
function cm.getlink_level(c)
	local e1=c:IsHasEffect(EFFECT_CHANGE_LEVEL_FINAL)
	if e1 then
		local value=e1:GetValue()
		if type(value)=='Effect' then
			return value(e1,c)
		end
		return value
	end
	local lvl=c:GetLink()
	local e2=c:IsHasEffect(EFFECT_CHANGE_LEVEL)
	if e2 then
		local value=e2:GetValue()
		if type(value)=='Effect' then
			lvl=value(e2,c)
		else
			lvl=value
		end
	end
	local eset={c:IsHasEffect(EFFECT_UPDATE_LEVEL)}
	for _,te in pairs(eset) do
		local value=te:GetValue()
		if type(value)=='Effect' then
			lvl=lvl+value(te,c)
		else
			lvl=lvl+value
		end
	end
	return lvl
end
if not cm.hack then
	cm.hack=true
	cm.getlevel=Card.GetLevel
	cm.islevel=Card.IsLevel
	cm.islevela=Card.IsLevelAbove
	cm.islevelb=Card.IsLevelBelow
	cm.islevelx=Card.IsXyzLevel
	Card.GetLevel=function (c)
		if c:GetOriginalCodeRule()==m then
			return cm.getlink_level(c)
		end
		return cm.getlevel(c)
	end
	Card.IsLevel=function(c,...)
		local expara={...}
		if c:GetOriginalCodeRule()==m then
			local lvl=cm.getlink_level(c)
			for _,i in pairs(expara) do
				if i==lvl then return true end
			end
			return false
		end
		return cm.islevel(c,table.unpack(expara))
	end
	Card.IsLevelAbove=function(c,tglv)
		if c:GetOriginalCodeRule()==m then
			return cm.getlink_level(c)>=tglv
		end
		return cm.islevela(c,tglv)
	end
	Card.IsLevelBelow=function(c,tglv)
		if c:GetOriginalCodeRule()==m then
			return cm.getlink_level(c)<=tglv
		end
		return cm.islevelb(c,tglv)
	end
end
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,cm.linkfilter,1,1)
end
function cm.linkfilter(c)
	return c:IsSetCard(0x163) and not c:IsType(TYPE_SYNCHRO)
end